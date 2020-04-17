/*
 * ==========================================================================================
 * =                            JAHIA'S ENTERPRISE DISTRIBUTION                             =
 * ==========================================================================================
 *
 *                                  http://www.jahia.com
 *
 * JAHIA'S ENTERPRISE DISTRIBUTIONS LICENSING - IMPORTANT INFORMATION
 * ==========================================================================================
 *
 *     Copyright (C) 2002-2020 Jahia Solutions Group. All rights reserved.
 *
 *     This file is part of a Jahia's Enterprise Distribution.
 *
 *     Jahia's Enterprise Distributions must be used in accordance with the terms
 *     contained in the Jahia Solutions Group Terms & Conditions as well as
 *     the Jahia Sustainable Enterprise License (JSEL).
 *
 *     For questions regarding licensing, support, production usage...
 *     please contact our team at sales@jahia.com or go to http://www.jahia.com/license.
 *
 * ==========================================================================================
 */
package org.jahia.modules.actions;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.module.jaxb.JaxbAnnotationIntrospector;
import com.ning.http.client.AsyncCompletionHandler;
import com.ning.http.client.AsyncHttpClient;
import com.ning.http.client.Response;
import org.apache.commons.lang.StringUtils;
import org.apache.unomi.api.*;
import org.jahia.api.Constants;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.exceptions.JahiaRuntimeException;
import org.jahia.modules.jexperience.admin.ContextServerService;
import org.jahia.services.content.JCRCallback;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.content.JCRTemplate;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.jahia.services.usermanager.JahiaUser;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.*;

/**
 * <h1>UpdateProfile</h1>
 * <p>
 * The UpdateProfile class implement an action that simply update the profile properties in Unomi
 * using an event of type "updateProperties". The value of this profile properties passed from AJAX
 * call with a POST method contains the json object
 * <p>
 * The updated profile properties:
 * - Universe
 *
 * @author Jahia
 */
public class UpdateProfile extends Action {
    private static Logger logger = LoggerFactory.getLogger(UpdateProfile.class);
    private ContextServerService contextServerService;
    private JCRTemplate jcrTemplate;

    @Override
    public ActionResult doExecute(final HttpServletRequest req, final RenderContext renderContext,
                                  final Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters,
                                  URLResolver urlResolver) throws Exception {

        String dataObject = new BufferedReader(new InputStreamReader(req.getInputStream())).readLine();
        JSONObject jsonOject = new JSONObject(dataObject);

        final String profileId = jsonOject.optString("profileId");
        final String sessionId = jsonOject.optString("sessionId");
        final String universeId = jsonOject.optString("universeId");
        final String universeValue = jsonOject.optString("universeValue");

        final JahiaUser jahiaUser = renderContext.getUser();

        jcrTemplate.doExecuteWithSystemSessionAsUser(jahiaUser, Constants.LIVE_WORKSPACE, session.getLocale(),
                new JCRCallback() {
                    @Override
                    public Object doInJCR(JCRSessionWrapper session) throws RepositoryException {
                        String siteKey = renderContext.getSite().getSiteKey();

                        final AsyncHttpClient asyncHttpClient = contextServerService
                                .initAsyncHttpClient(siteKey);

                        AsyncHttpClient.BoundRequestBuilder requestBuilder = contextServerService.initAsyncRequestBuilder(
                                        siteKey, asyncHttpClient, "/eventcollector?sessionId=" + sessionId, false,
                                        true, true);

                        Item source = new CustomItem();
                        source.setScope(siteKey);
                        source.setItemId("wemProfile");
                        source.setItemType("wemProfile");

                        Event event = new Event("updateProperties",
                                null,
                                new Profile(profileId),
                                siteKey,
                                source,
                                null,
                                new Date());

                        Map<String, Object> map = new HashMap<>();

                        if (StringUtils.isNotEmpty(universeId)) {
                            map.put("properties." + universeId, universeValue);
                        }
                        event.setProperty("update", map);
                        event.setProperty("targetId", profileId);
                        event.setProperty("targetType", Profile.ITEM_TYPE);

                        EventsCollectorRequest eventCollectorRequest = new EventsCollectorRequest();
                        eventCollectorRequest.setEvents(Arrays.asList(event));

                        ObjectMapper mapper = new ObjectMapper();
                        mapper.setAnnotationIntrospector(new JaxbAnnotationIntrospector(TypeFactory.defaultInstance()));

                        try {
                            String eventJson = mapper.writeValueAsString(eventCollectorRequest);

                            requestBuilder.setBody(eventJson);
                            requestBuilder.execute(new AsyncCompletionHandler<Response>() {
                                @Override
                                public Response onCompleted(Response response) {
                                    asyncHttpClient.closeAsynchronously();
                                    return response;
                                }
                            });
                        } catch (JsonProcessingException e) {
                            throw new JahiaRuntimeException(e);
                        }

                        session.save();
                        return null;
                    }
                });

        JSONObject jsonResult = new JSONObject();
        if (StringUtils.isNotEmpty(universeId)) {
            jsonResult.put("status", "update-universe-property");
        } else {
            jsonResult.put("status", "error");
        }

        return new ActionResult(HttpServletResponse.SC_OK, null, jsonResult);
    }

    public void setContextServerService(ContextServerService contextServerService) {
        this.contextServerService = contextServerService;
    }

    public void setJcrTemplate(JCRTemplate jcrTemplate) {
        this.jcrTemplate = jcrTemplate;
    }
}
