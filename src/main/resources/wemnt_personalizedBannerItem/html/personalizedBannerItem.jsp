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
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<c:url var="pathURL" value="${url.base}${currentNode.parent.parent.path}"/>
<c:set var="universe" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="callToAction" value="${currentNode.properties['callToAction'].node}"/>
<c:set var="callToActionURL" value="${callToAction.url}"/>
<c:set var="ctaLabel" value="${currentNode.properties['ctaLabel'].string}"/>
<c:set var="ctaStartColor" value="${currentNode.properties['ctaStartColor'].string}"/>
<c:set var="ctaEndColor" value="${currentNode.properties['ctaEndColor'].string}"/>
<c:set var="ctaTextColor" value="${currentNode.properties['ctaTextColor'].string}"/>
<c:set var="webSiteFooterBottomColor" value="${currentNode.properties['webSiteFooterBottomColor'].string}"/>
<c:set var="webSiteFooterTopColor" value="${currentNode.properties['webSiteFooterTopColor'].string}"/>
<c:set var="webSiteHeaderBottomColor" value="${currentNode.properties['webSiteHeaderBottomColor'].string}"/>
<c:set var="webSiteHeaderTopColor" value="${currentNode.properties['webSiteHeaderTopColor'].string}"/>
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
     class="mfb-banner-item container-fluid">
    <div id="main-banner-background"
         class="main-dd-selector"
         style="background: url('${url.context}${url.files}${backgroundImage.node.path}');">
        <h3>${moduleMap.primaryText},<br>${moduleMap.secondaryText}</h3>
        <h4>
            <span>${moduleMap.universeSelectorLabel}</span>
            <div class="btn-group">
                <button type="button"
                        class="btn btn-default dropdown-toggle"
                        data-toggle="dropdown">
                    <span id="mfbSelectionDropdown">${universe}</span>
                    <span class="material-icons">keyboard_arrow_down</span>
                </button>
                <ul class="dropdown-menu" role="menu">
                    <c:forEach items="${moduleMap.variants}" var="variant">
                        <jcr:nodeProperty node="${variant}" name="ctaLabel" var="variantCtaLabel"/>
                        <jcr:nodeProperty node="${variant}" name="ctaStartColor" var="variantCtaStartColor"/>
                        <jcr:nodeProperty node="${variant}" name="ctaEndColor" var="variantCtaEndColor"/>
                        <jcr:nodeProperty node="${variant}" name="ctaTextColor" var="variantCtaTextColor"/>
                        <jcr:nodeProperty node="${variant}" name="webSiteHeaderTopColor" var="variantWebSiteHeaderTopColor"/>
                        <jcr:nodeProperty node="${variant}" name="webSiteHeaderBottomColor" var="variantWebSiteHeaderBottomColor"/>
                        <jcr:nodeProperty node="${variant}" name="webSiteFooterTopColor" var="variantWebSiteFooterTopColor"/>
                        <jcr:nodeProperty node="${variant}" name="webSiteFooterBottomColor" var="variantWebSiteFooterBottomColor"/>
                        <jcr:nodeProperty node="${variant}" name="backgroundImage" var="VariantBackgroundImage"/>
                        <c:set var="variantCallToAction" value="${variant.properties['callToAction'].node}"/>
                        <c:set var="variantCallToActionURL" value="${variantCallToAction.url}"/>

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

                        <li>
                            <a href="#"
                               onclick='mfb.onChangeSelection(
                                        <json:object>
                                           <json:property name="universe" value="${functions:escapeJavaScript(variant.name)}"/>
                                           <json:property name="callToActionURL" value="${variantCallToActionURL}"/>
                                           <json:property name="ctaLabel" value="${functions:escapeJavaScript(variantCtaLabel)}"/>
                                           <json:property name="ctaStartColor" value="${variantCtaStartColor}"/>
                                           <json:property name="ctaEndColor" value="${variantCtaEndColor}"/>
                                           <json:property name="ctaTextColor" value="${variantCtaTextColor}"/>
                                           <json:property name="webSiteHeaderTopColor" value="${variantWebSiteHeaderTopColor}"/>
                                           <json:property name="webSiteHeaderBottomColor" value="${variantWebSiteHeaderBottomColor}"/>
                                           <json:property name="webSiteFooterTopColor" value="${variantWebSiteFooterTopColor}"/>
                                           <json:property name="webSiteFooterBottomColor" value="${variantWebSiteFooterBottomColor}"/>
                                           <json:property name="backgroundImageURL" value="${url.context}${url.files}${VariantBackgroundImage.node.path}"/>
                                        </json:object>
                                       );'
                            >
                                    ${variant.name}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </h4>

        <a id="cta_button"
           href="${callToActionURL}"
           class="btn btn-default cta-button ${buttonTextColorClass}"
           style="${buttonStyle} <c:if test="${empty ctaLabel}">visibility: hidden;</c:if>">
            <span id="cta_button_text">${ctaLabel}</span>
            <span class="material-icons">arrow_forward</span>
        </a>

        <input id="webSiteHeaderTopColor" value="${webSiteHeaderTopColor}" type="hidden">
        <input id="webSiteHeaderBottomColor" value="${webSiteHeaderBottomColor}" type="hidden">
        <input id="webSiteFooterTopColor" value="${webSiteFooterTopColor}" type="hidden">
        <input id="webSiteFooterBottomColor" value="${webSiteFooterBottomColor}" type="hidden">
    </div>
</div>
