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

<template:addResources>
    <script type="text/javascript">
        function selectBannerItem(selectedBannerItem, selectedBannerLabel) {
            // Display the banner selected
            var banners = document.getElementsByClassName('mfb-banner-item');
            for (var i = 0; i < banners.length; i++) {
                banners[i].style.display = 'none';
            }
            var activeBanner = document.getElementById(selectedBannerItem);
            activeBanner.style.display = 'block';

            // Add active class to the label selected in the dropdown menu
            var dropdownSelector = document.getElementsByClassName('mf-dropdown-selector');
            for (var i = 0; i < dropdownSelector.length; i++) {
                dropdownSelector[i].classList.remove('active');
            }
            var activeBannerLabel = document.getElementById(selectedBannerLabel);
            activeBannerLabel.classList.add('active');
        }
    </script>
</template:addResources>

<div class="btn-group">
    <button type="button"
            class="btn btn-default dropdown-toggle"
            data-toggle="dropdown">
        <span><fmt:message key="personalizedBanner.dropdown.label.select"/></span>
        <span class="caret"></span>
    </button>
    <ul class="dropdown-menu" role="menu">
        <c:forEach items="${moduleMap.variants}" var="value" varStatus="status">
            <template:module node="${value}" view="select" editable="false"/>
        </c:forEach>
    </ul>
</div>

<c:if test="${not wem:isAvailable(renderContext.site.siteKey)}">
    <div class="wem-unomi-error">
        <fmt:message key="wem.error.apacheUnomi"/>
    </div>
</c:if>

<c:forEach items="${moduleMap.variants}" var="variant" varStatus="status">
    <template:module node="${variant}" view="edit">
        <template:param name="isNotFirst" value="${not status.first}"/>
        <template:param name="primaryText" value="${moduleMap.primaryText}"/>
        <template:param name="secondaryText" value="${moduleMap.secondaryText}"/>
        <template:param name="universeSelectorLabel" value="${moduleMap.universeSelectorLabel}"/>
    </template:module>
</c:forEach>
