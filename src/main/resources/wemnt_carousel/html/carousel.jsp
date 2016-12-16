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

<template:include view="editToolbar"/>

<c:if test="${not renderContext.editMode or not editableVariants}">
    <c:set var="carouselItems" value="${jcr:getChildrenOfType(currentNode, 'wemnt:carouselItem')}"/>
    <c:set var="personalizationActive" value="${wem:isPersonalizationActive(currentNode)}"/>
    <c:set var="ajaxRender" value="${currentNode.properties['wem:ajaxRender'].boolean}"/>
    <c:set value="false" var="hasIdealNumber"/>
    <c:set value="0" var="idealNumberOfItems"/>
    <c:if test="${not empty currentNode.properties['wem:idealNumberOfItems']}">
        <c:set value="${currentNode.properties['wem:idealNumberOfItems'].long}" var="idealNumberOfItems"/>
        <c:set value="true" var="hasIdealNumber"/>
    </c:if>

    <c:set var="elementID" value="smartCarousel-${currentNode.identifier}" />
    <c:choose>
        <c:when test="${personalizationActive}">
            <template:addResources type="css" resources="bootstrap.min.css"/>
            <template:addResources type="javascript" resources="jquery.min.js,bootstrap.min.js"/>

            <c:set var="parsedId" value="${fn:replace(currentNode.identifier,'-','_')}"/>

            <c:choose>
                <c:when test="${ajaxRender}">

                    <c:set var="useIndicators" value="${currentNode.properties['useIndicators'].boolean}"/>

                    <template:addResources>
                        <script type="text/javascript">
                            function smartCarouselCallback${fn:replace(currentNode.identifier, '-', '')} (successfulFilters) {
                                // clean container
                                $('#carouselInner_${currentNode.identifier}').html('');
                                $('#carouselIndicators_${currentNode.identifier}').html('');

                                var hasIdealNumber = ${hasIdealNumber};
                                var idealNumberOfItems = ${idealNumberOfItems};
                                var generateImage = function (content, cssClass) {
                                    $('#carouselInner_${currentNode.identifier}').append('<div class="' + cssClass + '"></div>');
                                    $('#carouselInner_${currentNode.identifier} div').last().load(content);
                                };
                                var generateIndicators = function (cssClass, index) {
                                    if (${useIndicators}) {
                                        $('#carouselIndicators_${currentNode.identifier}').append('<li data-target="#${elementID}" data-slide-to="' + index + '" class="' + cssClass + '"></li>');
                                    }
                                };
                                var fallbackVariants = [
                                    <c:forEach items="${carouselItems}" var="carouselItem" varStatus="status">
                                        <c:if test="${carouselItem.properties['isFallback'].boolean}">
                                            <c:if test="${not status.first}">,</c:if>
                                            {
                                                identifier: "${carouselItem.identifier}",
                                                content: "<c:url value="${url.base}${functions:escapePath(carouselItem.path)}.${functions:default(carouselItem.properties['j:view'].string, 'default')}.html.ajax"/>"
                                            }
                                        </c:if>
                                    </c:forEach>
                                ];

                                var isFirst = true;
                                var index = 0;
                                if (successfulFilters.length > 0) {
                                    for (var successVariant in successfulFilters) {
                                        if ((hasIdealNumber && index < idealNumberOfItems) || !hasIdealNumber) {
                                            generateImage(successfulFilters[successVariant].content, isFirst?'item active':'item');
                                            generateIndicators(isFirst?'active':'', index);
                                            isFirst = false;
                                            index++;
                                        }
                                    }

                                    if (hasIdealNumber && successfulFilters.length < idealNumberOfItems) {
                                        for (var fallbackVariant in fallbackVariants) {
                                            var exist = false;
                                            for (var sVariant in successfulFilters) {
                                                if (successfulFilters[sVariant].filterId == fallbackVariants[fallbackVariant].identifier) {
                                                    exist = true;
                                                }
                                            }
                                            if (!exist) {
                                                generateImage(fallbackVariants[fallbackVariant].content, isFirst?'item active':'item');
                                                generateIndicators(isFirst?'active':'', index);
                                                isFirst = false;
                                                index++;
                                            }
                                        }
                                    }
                                } else {
                                    if (fallbackVariants.length > 0) {
                                        for (var fVariant in fallbackVariants) {
                                            generateImage(fallbackVariants[fVariant].content, isFirst?'item active':'item');
                                            generateIndicators(isFirst?'active':'', index);
                                            isFirst = false;
                                            index++;
                                        }
                                    } else {
                                        $('${elementID}').hide();
                                    }
                                }
                            }
                        </script>
                    </template:addResources>

                    <div id="${elementID}" class="carousel slide" data-ride="carousel">
                        <%-- Indicators --%>
                        <c:if test="${useIndicators}">
                            <ol id="carouselIndicators_${currentNode.identifier}" class="carousel-indicators"></ol>
                        </c:if>

                        <%-- Wrapper for slides --%>
                        <div id="carouselInner_${currentNode.identifier}" class="carousel-inner" role="listbox" style="height: 500px;"></div>

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
                        (function(){
                            var filters = {
                                <c:forEach items="${carouselItems}" var="carouselItem" varStatus="varStatus">
                                    <c:set var="hasfilter" value="${not empty carouselItem.properties['wem:jsonFilter'].string}" />
                                    <c:set var="carouselItemFilter" value=""/>
                                    '${carouselItem.identifier}' : {
                                        <c:if test="${hasfilter}">
                                            <c:set var="carouselItemFilter" value="{\"appliesOn\":[{}],\"condition\":${carouselItem.properties['wem:jsonFilter'].string}}"/>
                                        </c:if>
                                        "filter": {
                                            "filterid": "${carouselItem.identifier}",
                                            "filters": [${carouselItemFilter}]
                                        },
                                        "content": "<c:url value="${url.base}${functions:escapePath(carouselItem.path)}.${functions:default(carouselItem.properties['j:view'].string, 'default')}.html.ajax"/>",
                                        "priority": -${varStatus.index + 1}
                                    }${!varStatus.last ? ',' : ''}
                                </c:forEach>
                            };

                            if(window.wem) {
                                window.wem.registerPersonalization(filters, null, '${elementID}', null, ${ajaxRender}, smartCarouselCallback${fn:replace(currentNode.identifier, '-', '')});
                            } else {
                                console.log("No wem available in page, can't register personalization.")
                            }
                        })();
                    </script>
                </c:when>

                <c:otherwise>
                    <c:set var="nodeToDisplay" value=""/>
                    <c:forEach items="${wem:getWemPersonalizedContent(renderContext.request, renderContext.site.siteKey, currentNode, null)}" var="variant">
                        <c:if test="${variant.value eq 'true' and fn:length(fn:split(nodeToDisplay, ' ')) lt idealNumberOfItems}">
                            <c:set var="nodeToDisplay" value="${nodeToDisplay} ${variant.key}"/>
                        </c:if>
                    </c:forEach>

                    <c:if test="${hasIdealNumber and fn:length(fn:split(nodeToDisplay, ' ')) lt idealNumberOfItems}">
                        <c:forEach items="${carouselItems}" var="carouselItem">
                            <c:if test="${carouselItem.properties['isFallback'].boolean and fn:length(fn:split(nodeToDisplay, ' ')) lt idealNumberOfItems and not functions:contains(nodeToDisplay, carouselItem.identifier)}">
                                <c:set var="nodeToDisplay" value="${nodeToDisplay} ${carouselItem.identifier}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <div id="${elementID}" class="carousel slide" data-ride="carousel">
                        <%-- Indicators --%>
                        <c:if test="${currentNode.properties['useIndicators'].boolean}">
                            <ol class="carousel-indicators">
                                <c:forEach items="${fn:split(nodeToDisplay, ' ')}" var="variantIdentifier" varStatus="status">
                                    <jcr:node var="currentVariant" uuid="${variantIdentifier}"/>
                                    <li data-target="#${elementID}" data-slide-to="${status.index}" <c:if test='${status.index == 0}'>class="active"</c:if>></li>
                                </c:forEach>
                            </ol>
                        </c:if>

                        <%-- Wrapper for slides --%>
                        <div class="carousel-inner" role="listbox" style="height: 500px;">
                            <c:forEach items="${fn:split(nodeToDisplay, ' ')}" var="variantIdentifier" varStatus="status">
                                <jcr:node var="currentVariant" uuid="${variantIdentifier}"/>
                                <div class="item <c:if test='${status.first}'>active</c:if>">
                                    <template:module node="${currentVariant}" nodeTypes="wemnt:carouselItem"/>
                                </div>
                            </c:forEach>
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
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <c:set var="nodeToDisplay" value=""/>
            <c:if test="${hasIdealNumber and fn:length(fn:split(nodeToDisplay, ' ')) lt idealNumberOfItems}">
                <c:forEach items="${carouselItems}" var="carouselItem">
                    <c:if test="${carouselItem.properties['isFallback'].boolean and fn:length(fn:split(nodeToDisplay, ' ')) lt idealNumberOfItems}">
                        <c:set var="nodeToDisplay" value="${nodeToDisplay} ${carouselItem.identifier}"/>
                    </c:if>
                </c:forEach>
            </c:if>

            <c:if test="${fn:length(nodeToDisplay) gt 0}">
                <div id="${elementID}" class="carousel slide" data-ride="carousel">
                        <%-- Indicators --%>
                    <c:if test="${currentNode.properties['useIndicators'].boolean}">
                        <ol class="carousel-indicators">
                            <c:forEach items="${fn:split(nodeToDisplay, ' ')}" var="variantIdentifier" varStatus="status">
                                <jcr:node var="currentVariant" uuid="${variantIdentifier}"/>
                                <li data-target="#${elementID}" data-slide-to="${status.index}" <c:if test='${status.index == 0}'>class="active"</c:if>></li>
                            </c:forEach>
                        </ol>
                    </c:if>

                        <%-- Wrapper for slides --%>
                    <div class="carousel-inner" role="listbox" style="height: 500px;">
                        <c:forEach items="${fn:split(nodeToDisplay, ' ')}" var="variantIdentifier" varStatus="status">
                            <jcr:node var="currentVariant" uuid="${variantIdentifier}"/>
                            <div class="item <c:if test='${status.first}'>active</c:if>">
                                <template:module node="${currentVariant}" nodeTypes="wemnt:carouselItem"/>
                            </div>
                        </c:forEach>
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
            </c:if>
        </c:otherwise>
    </c:choose>
</c:if>
