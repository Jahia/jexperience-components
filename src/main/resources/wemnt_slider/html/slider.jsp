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
<c:set var="sliderPanels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
<c:set var="uuid" value="${currentNode.identifier}"/>
<c:set var="id" value="${fn:replace(uuid,'-', '')}"/>
<c:set var="transition" value="${currentNode.properties.transition.string}"/>
<c:set var="layout" value="${currentNode.properties.layout.string}"/>
<c:set var="autoplay" value="${currentNode.properties.autoplay.string}"/>
<c:set var="editview" value="${currentNode.properties.editview.string}"/>
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
<c:if test="${empty editview}">
    <c:set var="editview" value="edit"/>
</c:if>

<c:choose>
    <c:when test="${renderContext.editMode}">
        <template:include view="${editview}"/>
        <template:module path="*" nodeTypes="wemnt:sliderPanel"/>
    </c:when>
    <c:otherwise>
        <%-- get the child sliderPanels --%>
        <c:set var="panels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
        <div class='container'>
            <div class="ism-slider" id="mainSlider${id}">
                <ol>
                    <c:forEach items="${panels}" var="panel" varStatus="item">
                        <template:module node="${panel}" nodeTypes="wemnt:sliderPanel" editable="true">
                            <template:param name="layout" value="${layout}"/>
                        </template:module>
                    </c:forEach>
                </ol>
            </div>
        </div>
        <c:if test="${currentNode.properties['wem:active'].boolean}">
        <script type="text/javascript">
            function sliderPanelCallback${fn:replace(currentNode.identifier, '-', '')}(successfulFilters) {
                var idealNumberOfPanels = ${currentNode.properties["wem:idealNumberOfPanels"].long};
                var maxNumberOfPanels = ${currentNode.properties["wem:maxNumberOfPanels"].long};
                var displayedNumberOfPanels = 0;
                console.log(successfulFilters);
                for (var i in sliderFilters) {
                    var successFilterFound = undefined;
                    for (var j in successfulFilters) {
                        if (successfulFilters[j].filterId === sliderFilters[i].filter.filterid) {
                            if(maxNumberOfPanels > 0 && displayedNumberOfPanels >= maxNumberOfPanels) {
                                document.getElementById("sliderPanel" + sliderFilters[i].filter.filterid).remove();
                            } else {
                                successFilterFound = sliderFilters[i];
                                displayedNumberOfPanels++;
                            }
                            break;
                        }
                    }
                    console.log(successFilterFound);
                    if (!successFilterFound && maxNumberOfPanels > 0 && displayedNumberOfPanels < maxNumberOfPanels) {
                        if(sliderFilters[i].isFallback && displayedNumberOfPanels < idealNumberOfPanels) {
                            displayedNumberOfPanels++;
                        } else {
                            if(sliderFilters[i].filter.filters.length > 0) {
                                document.getElementById("sliderPanel" + sliderFilters[i].filter.filterid).remove();
                            }
                        }
                    }
                }
                window.ISM.instances[0].deinit();
                new window.ISM.Slider('mainSlider${id}', {play_type: '${autoplay? "loop" : "manual"}', transition_type: '${not empty transition ? transition : "slide"}'})
            }
        </script>
        <script type="text/javascript">
            var sliderFilters = {};
            (function () {
                sliderFilters = {
                    <c:forEach items="${sliderPanels}" var="sliderPanel" varStatus="varStatus">
                    <c:set var="hasfilter" value="${not empty sliderPanel.properties['wem:jsonFilter'].string}" />
                    <c:set var="sliderPanelFilter" value=""/>
                    '${sliderPanel.identifier}': {
                        <c:if test="${hasfilter}">
                            <c:set var="sliderPanelFilter" value="{\"appliesOn\":[{}],\"condition\":${sliderPanel.properties['wem:jsonFilter'].string}}"/>
                        </c:if>
                        "filter": {
                            "filterid": "${sliderPanel.identifier}",
                            "filters": [${sliderPanelFilter}]
                        },
                        "isFallback": ${sliderPanel.properties['isFallback'].boolean},
                        "priority": -${varStatus.index + 1}
                    }${!varStatus.last ? ',' : ''}
                    </c:forEach>
                };
                console.log(sliderFilters);

                if (window.wem) {
                    window.wem.registerPersonalization(sliderFilters, null, '${elementID}', null, null, sliderPanelCallback${fn:replace(currentNode.identifier, '-', '')});
                } else {
                    console.log("No wem available in page, can't register personalization.")
                }
            })();
        </script>
        </c:if>
    </c:otherwise>
</c:choose>


