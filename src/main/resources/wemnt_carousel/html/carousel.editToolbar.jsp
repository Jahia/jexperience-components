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

    <template:addResources type="css" resources="wem.css" />
    <template:addResources type="javascript" resources="wem-edit-toolbar.js" />
    <c:set var="parsedId" value="${fn:replace(currentNode.identifier,'-','_')}"/>

    <div>
        <div style="clear: both">
            <div <c:if test="${not empty carouselItems}"> style="float: right;width: 150px;"</c:if> >
                <template:module path="*" nodeTypes="wemnt:carouselItem" />
            </div>

            <c:if test="${not empty carouselItems}">
                <div>
                    <div class=" x-component " style="border-width: 0;">
                        <div class=" x-component" style="overflow: hidden; z-index: 99999">
                            <div class=" button-placeholder x-component" style="overflow: visible;" onclick="wemEditToolbar.previous('${parsedId}')">
                                <img onmouseover="parent.disableGlobalSelection(true)" onmouseout="parent.disableGlobalSelection(false)" src="<c:url value="/modules/marketing-factory-core/img/arrow_left_blue.png"/>" class="gwt-Image x-component" >
                            </div>
                            <div class=" button-placeholder x-component" style="overflow: visible;">
                                <span onmouseover="parent.disableGlobalSelection(true)" onmouseout="parent.disableGlobalSelection(false)" id="wemEditToolbarCount${parsedId}"> </span>
                            </div>
                            <div class=" button-placeholder x-component" style="overflow: visible;" onclick="wemEditToolbar.next('${parsedId}')">
                                <img onmouseover="parent.disableGlobalSelection(true)" onmouseout="parent.disableGlobalSelection(false)" src="<c:url value="/modules/marketing-factory-core/img/arrow_right_blue.png"/>" class="gwt-Image x-component">
                            </div>
                            <c:if test="${editableVariants}" >
                                <div class=" button-placeholder x-component" style="overflow: visible;">
                                    <span onmouseover="parent.disableGlobalSelection(true)" onmouseout="parent.disableGlobalSelection(false)" onclick="window.parent.editContent('${currentNode.path}')" id="wemEditToolbarLabel${parsedId}"> </span>
                                </div>
                            </c:if>
                        </div>

                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        <c:forEach items="${carouselItems}" var="subchild"  varStatus="st">
            wemEditToolbar.addData('${parsedId}','${functions:escapeJavaScript(subchild.unescapedName)}');
        </c:forEach>
        <c:if test="${not empty carouselItems}">
            wemEditToolbar.view('${parsedId}');
        </c:if>
    </script>

    <c:if test="${renderContext.editMode && !resourceReadOnly}">
        <c:forEach items="${carouselItems}" var="subchild" varStatus="st">
            <div ${st.first ? '' : 'style="display: none"'}  id="wemEditToolbarContent${parsedId}${st.index}" class="tabs-wemEditToolbar-div wemEditToolbarParent${parsedId}">
                <template:module node="${subchild}" nodeTypes="wemnt:carouselItem" />
            </div>
        </c:forEach>
    </c:if>
    <div class="clear"></div>
</c:if>