<%@ page import="org.jahia.modules.marketingfactory.admin.MFConstants" %>
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

<c:set var="transition" value="${not empty currentNode.properties.transition.string ? currentNode.properties.transition.string : 'slide'}"/>
<c:set var="layout" value="${not empty currentNode.properties.layout.string ? currentNode.properties.layout.string : 'boxed'}"/>
<c:set var="autoplay" value="${not empty currentNode.properties.autoplay.string ? currentNode.properties.autoplay.string : 'false'}"/>
<c:set var="maxNumberOfPanels" value="${not empty currentNode.properties['wem:maxNumberOfPanels'] ? currentNode.properties['wem:maxNumberOfPanels'].long : 0}"/>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <template:include view="edit"/>
        <template:module path="*" nodeTypes="wemnt:sliderPanel"/>
    </c:when>
    <c:otherwise>
        <c:set var="sliderId" value="personalizedSlider_${currentNode.identifier}"/>
        <c:set var="sliderPanels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
        <c:if test="${maxNumberOfPanels eq 0}">
            <c:set var="maxNumberOfPanels" value="${fn:length(sliderPanels)}"/>
        </c:if>

        <div class="container">
            <div id="${sliderId}" class="ism-slider"
                    <c:if test="${autoplay}"> data-play_type="loop"</c:if>
                    <c:if test="${transition ne ''}">data-transition_type="${transition}"</c:if>>

                <ol>
                    <c:choose>
                        <c:when test="${wem:isPersonalizationActive(currentNode)}">
                            <script type="text/javascript">
                                wemHasServerSideRendering = true;
                            </script>

                            <c:set var="jsonPersonalization" value="${wem:getWemPersonalizationRequest(currentNode)}"/>

                            <mf:ssrExperience type="<%= MFConstants.PERSONALIZATION %>" personalization="${fn:escapeXml(jsonPersonalization)}" multiple="true">
                                <c:forEach items="${sliderPanels}" var="sliderPanel">
                                    <mf:ssrVariant id="${sliderPanel.identifier}">
                                        <template:module node="${sliderPanel}" nodeTypes="wemnt:sliderPanel" editable="true">
                                            <template:param name="layout" value="${layout}"/>
                                        </template:module>
                                    </mf:ssrVariant>
                                </c:forEach>
                            </mf:ssrExperience>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${sliderPanels}" var="sliderPanel" end="${maxNumberOfPanels}">
                                <template:module node="${sliderPanel}" nodeTypes="wemnt:sliderPanel" editable="true">
                                    <template:param name="layout" value="${layout}"/>
                                </template:module>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ol>
            </div>

            <script type="text/javascript">
                (function () {
                    var maxItems = ${maxNumberOfPanels};

                    $("#${sliderId} > ol > *").each(function (index) {
                        if (maxItems > 0 && (index + 1) > maxItems) {
                            $(this).remove();
                        }
                    });
                })();
            </script>
        </div>
    </c:otherwise>
</c:choose>
