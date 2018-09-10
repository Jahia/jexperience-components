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
    <template:addResources type="javascript" resources="personalized-banner/marketing-factory-banner.js"/>
    <template:addResources type="javascript" resources="personalized-banner/lib/watch.js"/>
</c:if>

<c:set var="primaryText" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="secondaryText" value="${currentNode.properties['secondaryText'].string}"/>
<c:set var="universeSelectorLabel" value="${currentNode.properties['universeSelectorLabel'].string}"/>
<c:set var="universeId" value="${currentNode.properties['universeId'].string}"/>
<c:set var="dmpId" value="${currentNode.properties['dmpId'].string}"/>
<c:set var="dmpJSVariable" value="${currentNode.properties['dmpJSVariable'].string}"/>
<c:url var="pathURL" value="${url.base}${currentNode.parent.parent.path}"/>

<c:set target="${moduleMap}" property="variants" value="${jcr:getChildrenOfType(currentNode, 'wemnt:personalizedBannerItem')}"/>
<c:set target="${moduleMap}" property="primaryText" value="${primaryText}"/>
<c:set target="${moduleMap}" property="secondaryText" value="${secondaryText}"/>
<c:set target="${moduleMap}" property="universeSelectorLabel" value="${universeSelectorLabel}"/>
<c:set target="${moduleMap}" property="universeId" value="${universeId}"/>
<c:set target="${moduleMap}" property="dmpId" value="${dmpId}"/>
<c:set target="${moduleMap}" property="dmpJSVariable" value="${dmpJSVariable}"/>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <template:include view="edit"/>
        <template:module path="*" nodeTypes="wemnt:personalizedBannerItem"/>
    </c:when>
    <c:otherwise>
        <c:set var="mfBannerItem" value="${wem:getWemPersonalizedContents(renderContext.request, renderContext.site.siteKey, currentNode, null)}"/>

        <c:if test="${not empty mfBannerItem}">
            <jcr:node var="currentVariant" uuid="${mfBannerItem[0]}"/>
            <template:option nodetype="wemnt:personalizedBannerItem" node="${currentVariant}" view="default"/>
        </c:if>

        <input id="dmpJSVariable" value="${moduleMap.dmpJSVariable}" type="hidden">
        <input id="universeId" value="${universeId}" type="hidden">
        <input id="dmpId" value="${dmpId}" type="hidden">
        <input id="pathURL" value="${pathURL}" type="hidden">
    </c:otherwise>
</c:choose>

<c:if test="${renderContext.liveMode}">
    <script type="text/javascript">
        mfb.init();
    </script>
</c:if>
