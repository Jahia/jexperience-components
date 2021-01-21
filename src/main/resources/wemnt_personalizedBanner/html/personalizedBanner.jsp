<%@ page import="org.jahia.modules.jexperience.admin.Constants" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%@ taglib prefix="wem" uri="http://www.jahia.org/tags/wem" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css" resources="vendor/material-icons.css"/>
<template:addResources type="css" resources="personalized-banner.css"/>
<c:if test="${renderContext.liveMode}">
    <template:addResources type="javascript" resources="personalized-banner/jexperience-banner.js"/>
    <template:addResources type="javascript" resources="personalized-banner/lib/watch.js"/>
</c:if>

<c:set var="primaryText" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="secondaryText" value="${currentNode.properties['secondaryText'].string}"/>
<c:set var="universeSelectorLabel" value="${currentNode.properties['universeSelectorLabel'].string}"/>
<c:set var="universeId" value="${currentNode.properties['universeId'].string}"/>
<c:url var="pathURL" value="${url.base}${currentNode.parent.parent.path}"/>

<c:set target="${moduleMap}" property="variants" value="${jcr:getChildrenOfType(currentNode, 'wemnt:personalizedBannerItem')}"/>
<c:set target="${moduleMap}" property="primaryText" value="${primaryText}"/>
<c:set target="${moduleMap}" property="secondaryText" value="${secondaryText}"/>
<c:set target="${moduleMap}" property="universeSelectorLabel" value="${universeSelectorLabel}"/>
<c:set target="${moduleMap}" property="universeId" value="${universeId}"/>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <div class=" button-placeholder x-component" style="overflow: visible;">
            <span onmouseover="parent.disableGlobalSelection(true)"
                  onmouseout="parent.disableGlobalSelection(false)"
                  onclick="window.top.jExperienceHook.open('wem-edit-engine-cpmnt-perso', '${currentNode.path}')"
            >
                <img style="width: 16px; height: 16px"
                     src="<c:url value="/modules/jexperience/images/icons/personalization.svg"/>">
                <fmt:message key="wem.label.edit.personalization"/>
            </span>
        </div>

        <template:include view="edit"/>
        <template:module path="*" nodeTypes="wemnt:personalizedBannerItem"/>
    </c:when>
    <c:otherwise>
        <c:choose>
            <c:when test="${wem:isPersonalizationActive(currentNode)}">
                <script type="text/javascript">
                    wemHasServerSideRendering = true;
                </script>

                <c:set var="jsonPersonalization" value="${wem:getWemPersonalizationRequest(currentNode)}"/>

                <jx:ssrExperience id="${currentNode.identifier}"  multiple="false">
                    <c:forEach items="${moduleMap.variants}" var="variant">
                        <jx:ssrVariant id="${variant.identifier}">
                            <template:option nodetype="wemnt:personalizedBannerItem" node="${variant}" view="default"/>
                        </jx:ssrVariant>
                    </c:forEach>
                </jx:ssrExperience>

                <input id="universeId" value="${universeId}" type="hidden">
                <input id="pathURL" value="${pathURL}" type="hidden">
            </c:when>
            <c:otherwise>
                <c:forEach items="${moduleMap.variants}" var="variant" varStatus="status">
                    <c:if test="${status.first}">
                        <template:option nodetype="wemnt:personalizedBannerItem" node="${variant}" view="default"/>
                    </c:if>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>
