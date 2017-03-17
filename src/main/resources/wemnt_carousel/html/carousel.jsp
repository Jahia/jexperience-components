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
    <c:set var="maxNumberOfItems" value="0"/>
    <c:if test="${not empty currentNode.properties['wem:maxNumberOfItems']}">
        <c:set var="maxNumberOfItems" value="${currentNode.properties['wem:maxNumberOfItems'].long}"/>
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
                            var smartCarousel${fn:replace(currentNode.identifier, '-', '')} = {
                                callback: function(successfulFilters) {
                                    // clean container
                                    $('#carouselInner_${currentNode.identifier}').html('');
                                    $('#carouselIndicators_${currentNode.identifier}').html('');

                                    var maxNumberOfItems = ${maxNumberOfItems};

                                    // create an array of fallback = all variants with no conditions
                                    var fallback = [];
                                    for (var vi in smartCarousel${fn:replace(currentNode.identifier, '-', '')}.filters) {
                                        if (smartCarousel${fn:replace(currentNode.identifier, '-', '')}.filters[vi].filter.filters.length == 0) {
                                            fallback.push(smartCarousel${fn:replace(currentNode.identifier, '-', '')}.filters[vi]);
                                        }
                                    }

                                    // if we have successful result or fallback then we can built our view
                                    if (successfulFilters.length > 0 || fallback.length > 0) {
                                        // remove result if needed
                                        if (successfulFilters.length > maxNumberOfItems) {
                                            successfulFilters.slice(0, maxNumberOfItems);
                                        }
                                        // add fallback to reach max number of items
                                        if (successfulFilters.length < maxNumberOfItems) {
                                            for (var i in fallback) {
                                                if (successfulFilters.length < maxNumberOfItems) {
                                                    successfulFilters.push(fallback[i]);
                                                }
                                            }
                                        }

                                        var isFirst = true;
                                        for (var index = 0 ; index < successfulFilters.length ; index++) {
                                            $('#carouselInner_${currentNode.identifier}').append('<div class="item ' + (isFirst ? ' active' : '') + '"></div>');
                                            $('#carouselInner_${currentNode.identifier} div').last().load(successfulFilters[index].content);
                                            if (${useIndicators}) {
                                                $('#carouselIndicators_${currentNode.identifier}').append('<li data-target="#${elementID}" data-slide-to="' + index + '" ' + (isFirst ? ' class="active"' : '') + '></li>');
                                            }
                                            isFirst = false;
                                        }
                                    } else {
                                        // nothing to display remove the carousel from the page
                                        document.getElementById('${elementID}').remove();
                                    }
                                },
                                filters: {
                                    <c:forEach items="${carouselItems}" var="carouselItem" varStatus="varStatus">
                                        <c:set var="carouselItemFilter" value=""/>
                                        <c:if test="${not empty carouselItem.properties['wem:jsonFilter'].string}">
                                            <c:set var="carouselItemFilter" value="{\"appliesOn\":[{}],\"condition\":${carouselItem.properties['wem:jsonFilter'].string}}"/>
                                        </c:if>
                                        '${carouselItem.identifier}' : {
                                            "filter": {
                                                "filterid": "${carouselItem.identifier}",
                                                "filters": [${carouselItemFilter}]
                                            },
                                            "content": "<c:url value="${url.base}${functions:escapePath(carouselItem.path)}.${functions:default(carouselItem.properties['j:view'].string, 'default')}.html.ajax"/>",
                                            "priority": -${varStatus.index + 1}
                                        }${!varStatus.last ? ',' : ''}
                                    </c:forEach>
                                }
                            };

                            if(window.wem) {
                                window.wem.registerPersonalization(smartCarousel${fn:replace(currentNode.identifier, '-', '')}.filters, null, '${elementID}', null, null, smartCarousel${fn:replace(currentNode.identifier, '-', '')}.callback);
                            } else {
                                console.log("No wem available in page, can't register personalization.")
                            }
                        })();
                    </script>
                </c:when>

                <c:otherwise>
                    <c:set var="nodeToDisplay" value=""/>
                    <c:set var="successFilterNodes" value="${wem:getWemPersonalizedContents(renderContext.request, renderContext.site.siteKey, currentNode, null)}"/>
                    <c:forEach items="${successFilterNodes}" var="variant">
                        <c:if test="${fn:length(fn:split(nodeToDisplay, ' ')) lt maxNumberOfItems}">
                            <c:set var="nodeToDisplay" value="${nodeToDisplay} ${variant}"/>
                        </c:if>
                    </c:forEach>

                    <c:if test="${fn:length(fn:split(nodeToDisplay, ' ')) lt maxNumberOfItems}">
                        <c:forEach items="${carouselItems}" var="carouselItem">
                            <c:if test="${empty carouselItem.properties['wem:jsonFilter'].string
                                              and fn:length(fn:split(nodeToDisplay, ' ')) lt maxNumberOfItems}">
                                <c:set var="nodeToDisplay" value="${nodeToDisplay} ${carouselItem.identifier}"/>
                            </c:if>
                        </c:forEach>
                    </c:if>

                    <c:if test="${not empty nodeToDisplay}">
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
        </c:when>
        <c:otherwise>
            <c:set var="nodeToDisplay" value=""/>
            <c:forEach items="${carouselItems}" var="carouselItem">
                <c:if test="${empty carouselItem.properties['wem:jsonFilter'].string
                                  and fn:length(fn:split(nodeToDisplay, ' ')) lt maxNumberOfItems}">
                    <c:set var="nodeToDisplay" value="${nodeToDisplay} ${carouselItem.identifier}"/>
                </c:if>
            </c:forEach>

            <c:if test="${not empty nodeToDisplay}">
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
