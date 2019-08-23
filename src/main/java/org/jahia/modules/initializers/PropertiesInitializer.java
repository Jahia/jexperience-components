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
 *     Copyright (C) 2002-2019 Jahia Solutions Group. All rights reserved.
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
package org.jahia.modules.initializers;

import com.ning.http.client.AsyncCompletionHandler;
import com.ning.http.client.AsyncHttpClient;
import com.ning.http.client.ListenableFuture;
import com.ning.http.client.Response;
import org.apache.jackrabbit.value.StringValue;
import org.jahia.modules.jexperience.admin.ContextServerService;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.decorator.JCRSiteNode;
import org.jahia.services.content.nodetypes.ExtendedPropertyDefinition;
import org.jahia.services.content.nodetypes.initializers.ChoiceListValue;
import org.jahia.services.content.nodetypes.initializers.ModuleChoiceListInitializer;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ExecutionException;

/**
 * <h1>MFPropertiesInitializer</h1>
 * <p>
 * The MFPropertiesInitializer class implement a ModuleChoiceListInitializer that simply add a list
 * of values to the field (the field used a choiceList initializer "MFPropertiesInitializer").
 * The MFPropertiesInitializer get the list of profile properties from Unomi and add it to the field
 * choiceList. The initializer has a parameter and according to this parameter we added the required
 * profiles properties to the field choiceList.
 * <p>
 * The MFPropertiesInitializer parameters:
 * - Single: to get only profile properties of type single text
 * - Multiple: to get only profile properties of type multivalued text
 *
 * @author MF-TEAM
 */
public class PropertiesInitializer implements ModuleChoiceListInitializer {

    private static final Logger logger = LoggerFactory.getLogger(PropertiesInitializer.class);
    private String key;
    private ContextServerService contextServerService;

    @Override
    public List<ChoiceListValue> getChoiceListValues(ExtendedPropertyDefinition epd, String param, List<ChoiceListValue> values, Locale locale, Map<String, Object> context) {
        List<ChoiceListValue> choiceListValues = new ArrayList<>();

        try {
            JCRNodeWrapper node = (JCRNodeWrapper)
                    ((context.get("contextParent") != null)
                            ? context.get("contextParent")
                            : context.get("contextNode"));

            JCRSiteNode site = node.getResolveSite();
            final AsyncHttpClient asyncHttpClient = contextServerService.initAsyncHttpClient(site.getSiteKey());

            if (asyncHttpClient != null) {
                AsyncHttpClient.BoundRequestBuilder requestBuilder = contextServerService.initAsyncRequestBuilder(
                                site.getSiteKey(), asyncHttpClient, "/cxs/profiles/properties", true, true, true);

                ListenableFuture<Response> future = requestBuilder.execute(new AsyncCompletionHandler<Response>() {
                    @Override
                    public Response onCompleted(Response response) {
                        asyncHttpClient.closeAsynchronously();
                        return response;
                    }
                });

                JSONObject responseBody = new JSONObject(future.get().getResponseBody());
                JSONArray profileProperties = responseBody.getJSONArray("profiles");

                for (int i = 0; i < profileProperties.length(); i++) {
                    JSONObject property = profileProperties.getJSONObject(i);
                    if (param.equals("single")
                            ? !property.optBoolean("multivalued") : property.optBoolean("multivalued")
                            && property.optString("type").equals("string")) {
                        String itemId = property.optString("itemId");
                        String displayName = property.getJSONObject("metadata").optString("name");

                        choiceListValues.add(new ChoiceListValue(displayName, null, new StringValue(itemId)));
                    }
                }
            }
        } catch (RepositoryException | InterruptedException | ExecutionException | IOException | JSONException e) {
            logger.error("Error happened", e);
        }

        return choiceListValues;
    }

    @Override
    public void setKey(String key) {
        this.key = key;
    }

    @Override
    public String getKey() {
        return key;
    }

    public void setContextServerService(ContextServerService contextServerService) {
        this.contextServerService = contextServerService;
    }
}
