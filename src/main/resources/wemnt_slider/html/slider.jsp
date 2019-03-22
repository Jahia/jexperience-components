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
        <c:set var="sliderId" value="personalizedSlider_${currentNode.identifier}"/>
        <c:set var="sliderPanels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
        <c:if test="${maxNumberOfPanels eq 0}">
            <c:set var="maxNumberOfPanels" value="${fn:length(sliderPanels)}"/>
        </c:if>

        <div class="container">
            <div id="${sliderId}" class="ism-slider"
                    <c:if test="${autoplay}"> data-play_type="loop"</c:if>
                    <c:if test="${transition ne ''}">data-transition_type="${transition}"</c:if>>

                <ol class="slider-panel-item">
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

                    $("[id=${sliderId}].ism-slider > ol.slider-panel-item li").each(function (index) {
                        if (maxItems > 0 && (index + 1) > maxItems) {
                            $(this).remove();
                        }
                    });
                })();
            </script>
        </div>
    </c:otherwise>
</c:choose>
