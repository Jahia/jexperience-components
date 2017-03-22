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
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="subtitle" value="${currentNode.properties.subtitle.string}"/>
<c:set var="summary" value="${currentNode.properties.body.string}"/>
<c:set var="background" value="${currentNode.properties.backgroundImg.node}"/>

<li id="sliderPanel${currentNode.identifier}" class="ism-img-${layout}">
    <jcr:nodeProperty var="image" node="${currentNode}" name="backgroundImg"/>
    <c:if test="${! empty image.node.url}">
        <c:url var="imageUrl" value="${image.node.url}" context="/"/>
    </c:if>
    <img src="${imageUrl}" alt="${fn:escapeXml(image.node.displayableName)}"/>
    <div class="ism-caption ism-caption-0">
        <c:if test="${not empty title}">
            <div class="ms-layer ms-promo-title"
                 data-effect="bottom(40)"
                 data-duration="2000"
                 data-delay="700"
                 data-ease="easeOutExpo">
                 ${title}
            </div>
        </c:if>
    </div>
    <div class="ism-caption ism-caption-1">
        <c:if test="${not empty subtitle}">
            <div class="ms-layer ms-promo-info-in ms-promo-info ms-promo-subtitle"
                 data-effect="bottom(40)"
                 data-duration="2000"
                 data-delay="1000"
                 data-ease="easeOutExpo">
                <span class="color-theme">${subtitle}</span>
            </div>
        </c:if>
    </div>
    <div class="ism-caption ism-caption-2" style="text-align: left">
        <c:if test="${not empty summary}">
            <div class="ms-layer ms-promo-sub" style="left:${textLayout};"
                 data-effect="bottom(40)"
                 data-duration="2000"
                 data-delay="1300"
                 data-ease="easeOutExpo">
                 ${summary}
            </div>
        </c:if>
        <c:if test="${not empty currentNode.properties.internalLink.node}">
            <c:url var="linkUrl" value="${currentNode.properties.internalLink.node.url}" context="/"/>
            <div class="ctaWrapper">
                <a class="ms-layer" href="${linkUrl}"
                   data-effect="bottom(40)"
                   data-duration="2000"
                   data-delay="1300"
                   data-ease="easeOutExpo"
                   alt="${title}">
                    ${currentNode.properties.linkText.string}
                </a>
            </div>
        </c:if>
    </div>
</li>