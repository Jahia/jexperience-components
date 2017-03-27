<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="wem" uri="http://www.jahia.org/tags/wem" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="subchild" type="org.jahia.services.content.JCRNodeWrapper"--%>
<template:addCacheDependency flushOnPathMatchingRegexp="\\\\Q${currentNode.path}\\\\E/[^/]*" />

<c:if test="${renderContext.editMode}">
    <c:set var="carouselItems" value="${jcr:getChildrenOfType(currentNode, 'wemnt:carouselItem')}"/>

    <c:if test="${not empty carouselItems}">
        <c:set var="elementID" value="smartCarousel-${currentNode.identifier}" />
        <c:set var="parsedId" value="${fn:replace(currentNode.identifier,'-','_')}"/>

        <div id="${elementID}" class="personalized-carousel carousel slide" data-ride="carousel">
            <div class="dropdown">
                <button class="btn btn-default dropdown-toggle" type="button" data-toggle="dropdown">
                    <fmt:message key="wemnt_carousel.editToolbar.label.selectImage"/>
                    <span class="caret"></span></button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="menu1">
                    <c:forEach items="${carouselItems}" var="carouselItem" varStatus="status">
                        <template:module node="${carouselItem}" view="select" editable="false">
                            <template:param name="currentIndex" value="${status.index}"/>
                            <template:param name="elementID" value="${elementID}"/>
                        </template:module>
                    </c:forEach>
                </ul>
            </div>

            <div class="carousel-inner" role="listbox">
                <c:forEach items="${carouselItems}" var="carouselItem" varStatus="status">
                    <div class="item <c:if test='${status.first}'>active</c:if>">
                        <template:module node="${carouselItem}" nodeTypes="wemnt:carouselItem" editable="${!resourceReadOnly}"/>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <template:module path="*" nodeTypes="wemnt:carouselItem" />
</c:if>