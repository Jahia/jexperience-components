<%@ page import="org.jahia.modules.jexperience.admin.Constants" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="wem" uri="http://www.jahia.org/tags/wem" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:set var="editableVariants" scope="request" value="${editableModule}"/>
<template:addResources type="css" resources="bootstrap.min.css,personalized-carousel.css"/>
<template:addResources type="javascript" resources="jquery.min.js,bootstrap.min.js"/>
<c:choose>
    <c:when test="${not renderContext.editMode or not editableVariants}">
        <c:set var="carouselItems" value="${jcr:getChildrenOfType(currentNode, 'wemnt:carouselItem')}"/>
        <c:set var="personalizationActive" value="${wem:isPersonalizationActive(currentNode)}"/>
        <c:set var="maxNumberOfItems"
               value="${not empty currentNode.properties['wem:maxNumberOfItems'] ? currentNode.properties['wem:maxNumberOfItems'].long : 0}"/>
        <c:set var="useIndicators" value="${currentNode.properties['useIndicators'].boolean}"/>
        <c:set var="elementID" value="smartCarousel-${currentNode.identifier}"/>

        <div id="${elementID}" class="personalized-carousel carousel slide" data-ride="carousel">
                <%-- Indicators --%>
            <c:if test="${useIndicators}">
                <ol class="carousel-indicators"></ol>
            </c:if>

                <%-- Wrapper for slides --%>
            <div class="carousel-inner" role="listbox">
                <c:choose>
                    <c:when test="${personalizationActive}">
                        <c:set var="jsonPersonalization" value="${wem:getWemPersonalizationRequest(currentNode)}"/>

                        <jx:ssrExperience id="${currentNode.identifier}" multiple="true">
                            <c:forEach items="${carouselItems}" var="currentVariant" varStatus="status">
                                <jx:ssrVariant id="${currentVariant.identifier}" variant-experience="${currentNode.identifier}">
                                    <div class="item active">
                                        <template:module node="${currentVariant}" nodeTypes="wemnt:carouselItem"/>
                                    </div>
                                </jx:ssrVariant>
                            </c:forEach>
                        </jx:ssrExperience>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${carouselItems}" var="currentVariant" varStatus="status">
                            <div class="item active">
                                <template:module node="${currentVariant}" nodeTypes="wemnt:carouselItem"/>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

                <%-- Controls --%>
            <c:if test="${currentNode.properties['useLeftAndRightControls'].boolean}">
                <a class="left carousel-control" href="#${elementID}" role="button" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only"><fmt:message key="wemnt_carousel.label.previous"/></span>
                </a>
                <a class="right carousel-control" href="#${elementID}" role="button" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only"><fmt:message key="wemnt_carousel.label.next"/></span>
                </a>
            </c:if>
        </div>

        <script type="text/javascript">
            wemHasServerSideRendering = true;
            (function () {
                var useIndicators = ${useIndicators};
                var maxItems = ${maxNumberOfItems};

                $("#${elementID} .carousel-inner > div.item").each(function (index) {
                    if (maxItems > 0 && (index + 1) > maxItems) {
                        // remove item in excess
                        $(this).remove();
                    } else {
                        if (index > 0) {
                            // keep only first item activate when displayed
                            $(this).removeClass("active");
                        }
                        if (useIndicators) {
                            // add indicator
                            $("#${elementID} .carousel-indicators")
                                .append("<li data-target='#${elementID}' data-slide-to='" + index + "' " +
                                    (index === 0 ? "class='active'" : "") + "></li>")
                        }
                    }
                });
            })();
        </script>
    </c:when>
    <c:otherwise>
        <template:include view="editToolbar"/>
    </c:otherwise>
</c:choose>