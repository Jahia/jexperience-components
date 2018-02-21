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
<template:addResources type="css" resources="perso-slider.css"/>
<c:if test="${!renderContext.editMode}">
    <template:addResources type="javascript" resources="ism-2.2.min.js"/>
</c:if>
<c:set var="escapedId" value="${fn:replace(currentNode.identifier, '-', '')}"/>
<c:set var="transition" value="${currentNode.properties.transition.string}"/>
<c:set var="layout" value="${currentNode.properties.layout.string}"/>
<c:set var="autoplay" value="${currentNode.properties.autoplay.string}"/>
<c:if test="${transition eq 'basic'}">
    <c:set var="transition" value=""/>
</c:if>
<c:if test="${not empty transition}">
    <c:set var="transition" value="${fn:toLowerCase(transition)}"/>
</c:if>
<c:if test="${empty layout}">
    <c:set var="layout" value="boxed"/>
</c:if>
<c:if test="${empty autoplay}">
    <c:set var="autoplay" value="false"/>
</c:if>
<c:set var="maxNumberOfPanels" value="0"/>
<c:if test="${not empty currentNode.properties['wem:maxNumberOfPanels']}">
    <c:set var="maxNumberOfPanels" value="${currentNode.properties['wem:maxNumberOfPanels'].long}"/>
</c:if>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <template:include view="edit"/>
        <template:module path="*" nodeTypes="wemnt:sliderPanel"/>
    </c:when>
    <c:otherwise>
        <c:set var="panels" value=""/>
        <c:choose>
            <c:when test="${currentNode.properties['wem:active'].boolean}">
                <c:set var="successFilterIdentifier" value="${wem:getWemPersonalizedContents(renderContext.request, renderContext.site.siteKey, currentNode, null)}"/>
                <c:forEach items="${successFilterIdentifier}" var="sliderPanel">
                    <c:if test="${maxNumberOfPanels eq 0 || (maxNumberOfPanels gt 0 and (fn:length(fn:split(panels, ' ')) lt maxNumberOfPanels) || panels eq '')}">
                        <c:set var="panels" value="${panels} ${sliderPanel}"/>
                    </c:if>
                </c:forEach>
                <c:if test="${renderContext.previewMode}">
                    <script type="text/javascript">
                        wemHasServerSideRendering = true;
                    </script>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:set var="sliderPanels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
                <c:forEach items="${sliderPanels}" var="sliderPanel">
                    <c:if test="${empty sliderPanel.properties['wem:jsonFilter'].string
                                    and (maxNumberOfPanels eq 0 || (maxNumberOfPanels gt 0 and (fn:length(fn:split(panels, ' ')) lt maxNumberOfPanels) || panels eq ''))}">
                        <c:set var="panels" value="${panels} ${sliderPanel}"/>
                    </c:if>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        <div class="container">
            <div class="ism-slider" id="personalizedSlider_${escapedId}"
                 <c:if test="${autoplay}"> data-play_type="loop"</c:if>
                 <c:if test="${transition ne ''}">data-transition_type="${transition}"</c:if> >
                <ol>
                    <c:forEach items="${fn:split(panels, ' ')}" var="panel" varStatus="item">
                        <jcr:node var="currentVariant" uuid="${panel}"/>
                        <template:module node="${currentVariant}" nodeTypes="wemnt:sliderPanel" editable="true">
                            <template:param name="layout" value="${layout}"/>
                        </template:module>
                    </c:forEach>
                </ol>
            </div>
        </div>
    </c:otherwise>
</c:choose>


