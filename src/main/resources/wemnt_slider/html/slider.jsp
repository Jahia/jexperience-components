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
<c:set var="sliderPanels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
<c:set var="uuid" value="${currentNode.identifier}"/>
<c:set var="id" value="${fn:replace(uuid,'-', '')}"/>
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

<c:choose>
    <c:when test="${renderContext.editMode}">
        <template:include view="edit"/>
        <template:module path="*" nodeTypes="wemnt:sliderPanel"/>
    </c:when>
    <c:otherwise>
        <c:if test="${currentNode.properties['wem:active'].boolean}">
            <script type="text/javascript">
                (function () {
                    var sliderPanel${fn:replace(currentNode.identifier, '-', '')} = {
                        callback: function(successfulFilters) {
                            // to simplify test and final result we will deal with an array of ID only
                            var successIds = [];
                            for (var i in successfulFilters) {
                                successIds.push(successfulFilters[i].filterId);
                            }

                            if (successIds.length > 0) {
                                // create an array of panels ID to remove
                                var panelsToRemove = [];
                                // to count the number of panels displayed
                                var totalPanelDisplayed = 0;

                                // iterate on all the variants
                                for (var variantIdentifier in sliderPanel${fn:replace(currentNode.identifier, '-', '')}.variants) {
                                    if (successIds.indexOf(variantIdentifier) === -1) {
                                        // if current variant is not part of success we add it to the remove array
                                        panelsToRemove.push(variantIdentifier);
                                    } else {
                                        // otherwise we increment the number of panel being displayed
                                        totalPanelDisplayed++;
                                    }
                                }

                                var maxNumberOfPanels = ${currentNode.properties["wem:maxNumberOfPanels"].long};
                                // if there is a maximum number of panel to display we check if the total is not superior
                                if (maxNumberOfPanels > 0 && totalPanelDisplayed > maxNumberOfPanels) {
                                    // total is superior to maximum so we reverse the array to start by the last one
                                    successIds.reverse();
                                    // in case we didn't reach the limit we remove some of the success
                                    for (var successID in successIds) {
                                        if (totalPanelDisplayed > maxNumberOfPanels) {
                                            panelsToRemove.push(successIds[successID]);
                                            totalPanelDisplayed--;
                                        }
                                    }
                                }

                                // execute the remove
                                for (var panel in panelsToRemove) {
                                    document.getElementById('sliderPanel' + panelsToRemove[panel]).remove();
                                }

                                // reload the slider
                                window.ISM.instances[0].deinit();
                                new window.ISM.Slider('personalizedSlider_${id}', {play_type: '${autoplay ? "loop" : "manual"}', transition_type: '${not empty transition ? transition : "slide"}'});
                            } else {
                                // nothing to display remove the slider from the page
                                window.ISM.instances[0].deinit();
                                document.getElementById('personalizedSlider_${id}').remove();
                            }
                        },
                        variants: ${wem:getVariants(currentNode, pageContext)}
                    };

                    if (window.wem) {
                        window.wem.registerPersonalizationObject(${wem:getWemPersonalizationRequest(currentNode)}, sliderPanel${fn:replace(currentNode.identifier, '-', '')}.variants, null, sliderPanel${fn:replace(currentNode.identifier, '-', '')}.callback);
                    } else {
                        console.log("No wem available in page, can't register personalization.")
                    }
                })();
            </script>
        </c:if>

        <%-- get the child sliderPanels --%>
        <c:set var="panels" value="${jcr:getChildrenOfType(currentNode, 'wemnt:sliderPanel')}"/>
        <div class="container">
            <div class="ism-slider" id="personalizedSlider_${id}">
                <ol>
                    <c:forEach items="${panels}" var="panel" varStatus="item">
                        <template:module node="${panel}" nodeTypes="wemnt:sliderPanel" editable="true">
                            <template:param name="layout" value="${layout}"/>
                        </template:module>
                    </c:forEach>
                </ol>
            </div>
        </div>
    </c:otherwise>
</c:choose>


