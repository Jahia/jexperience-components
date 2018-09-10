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

<c:if test="${renderContext.editMode}">
    <c:set var="universe" value="${currentNode.properties['jcr:title'].string}"/>
    <c:set var="callToAction" value="${currentNode.properties['callToAction'].string}"/>
    <c:set var="ctaLabel" value="${currentNode.properties['ctaLabel'].string}"/>
    <c:set var="ctaStartColor" value="${currentNode.properties['ctaStartColor'].string}"/>
    <c:set var="ctaEndColor" value="${currentNode.properties['ctaEndColor'].string}"/>
    <c:set var="ctaTextColor" value="${currentNode.properties['ctaTextColor'].string}"/>
    <jcr:nodeProperty node="${currentNode}" name="backgroundImage" var="backgroundImage"/>

    <c:choose>
        <c:when test="${ctaTextColor eq 'light'}">
            <c:set var="buttonTextColorClass" value="cta-text-color-light"/>
        </c:when>
        <c:otherwise>
            <c:set var="buttonTextColorClass" value="cta-text-color-dark"/>
        </c:otherwise>
    </c:choose>

    <c:choose>
        <c:when test="${not empty ctaStartColor and not empty ctaEndColor}">
            <c:set var="buttonStyle"
                   value="background: linear-gradient(45deg, ${ctaStartColor} 30%, ${ctaEndColor} 90%);"/>
        </c:when>
        <c:when test="${not empty ctaStartColor}">
            <c:set var="buttonStyle"
                   value="background: linear-gradient(45deg, ${ctaStartColor} 30%, ${ctaStartColor} 90%);"/>
        </c:when>
        <c:when test="${not empty ctaEndColor}">
            <c:set var="buttonStyle"
                   value="background: linear-gradient(45deg, ${ctaEndColor} 30%, ${ctaEndColor} 90%);"/>
        </c:when>
        <c:otherwise>
            <c:set var="buttonStyle" value=""/>
        </c:otherwise>
    </c:choose>

    <div id="mfb-banner-item-${currentNode.identifier}"
         class="mfb-banner-item container-fluid"
         style=<c:if test="${isNotFirst}">"display: none;"</c:if>
    >
        <div class="main-dd-selector main-dd-selector-edit"
             style="background: url('${url.context}${url.files}${backgroundImage.node.path}');">
            <h3>${primaryText},<br>${secondaryText}</h3>
            <h4>
                <span>${universeSelectorLabel}</span>
                <div class="btn-group">
                    <button type="button"
                            class="btn btn-default dropdown-toggle disabled"
                            data-toggle="dropdown">
                        <span>${universe}</span>
                        <span class="material-icons">keyboard_arrow_down</span>
                    </button>
                </div>
            </h4>

            <a class="btn btn-default cta-button disabled ${buttonTextColorClass}" style="${buttonStyle}">
                ${ctaLabel}
                <span class="material-icons">arrow_forward</span>
            </a>
        </div>
    </div>
</c:if>
