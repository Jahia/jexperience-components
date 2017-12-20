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

<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="listItems" value=""/>
<c:set var="successFilterIdentifier"
       value="${wem:getWemPersonalizedContents(renderContext.request, renderContext.site.siteKey, currentNode, null)}"/>

<c:forEach items="${successFilterIdentifier}" var="item">
    <c:set var="listItems" value="${listItems} ${item}"/>
</c:forEach>

<div class="container">
    <div id="listTitle_${currentNode.identifier}">
        <h2>${title}</h2>
    </div>
    <div id="personalizedList_${currentNode.identifier}">
        <c:choose>
            <c:when test="${!renderContext.editMode}">
                <ol id="listItem_${currentNode.identifier}">
                    <c:forEach items="${fn:split(listItems, ' ')}" var="listItem" varStatus="item">
                        <jcr:node var="currentVariant" uuid="${listItem}"/>
                        <template:module node="${currentVariant}" nodeTypes="wemnt:listItem" editable="true">
                        </template:module>
                    </c:forEach>
                </ol>
            </c:when>
            <c:otherwise>
                <ol id="listItem_${currentNode.identifier}">
                    <c:forEach items="${jcr:getChildrenOfType(currentNode, 'wemnt:listItem')}" var="listItem">
                        <template:module node="${listItem}" view="default"/>
                    </c:forEach>
                </ol>

                <template:module path="*"/>
            </c:otherwise>
        </c:choose>
    </div>
</div>
