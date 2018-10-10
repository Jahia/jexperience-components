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
<div class="container">
    <div id="listTitle_${currentNode.identifier}">
        <h2>${title}</h2>
    </div>
    <div id="personalizedList_${currentNode.identifier}">
        <c:choose>
            <c:when test="${!renderContext.editMode}">
                <c:if test="${renderContext.previewMode}">
                    <script type="text/javascript">
                        wemHasServerSideRendering = true;
                    </script>
                </c:if>
                <ol id="listItem_${currentNode.identifier}">
                    <c:choose>
                        <c:when test="${wem:isPersonalizationActive(currentNode)}">
                            <c:forEach items="${wem:getWemPersonalizedContents(renderContext.request, renderContext.site.siteKey, currentNode, null)}" var="variant">
                                <jcr:node var="currentVariant" uuid="${variant}"/>
                                <template:module node="${currentVariant}"/>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <template:module node="${currentNode.properties['wem:fallbackVariant'].node}"/>
                        </c:otherwise>
                    </c:choose>
                </ol>
            </c:when>
            <c:otherwise>
                <template:addResources type="javascript" resources="marketing-factory/edit-mode/wem-edit-toolbar.js" />

                <ol id="listItem_${currentNode.identifier}">
                    <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jmix:droppableContent')}" var="droppableContent">
                        <template:module node="${droppableContent}" editable="true"/>
                    </c:forEach>
                </ol>

                <c:set var="parsedId" value="${fn:replace(currentNode.identifier,'-','_')}"/>
                <div id="wemToolbarJahiaButtons${parsedId}">
                    <template:module path="*"/>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function() {
                        <c:forEach items="${jcr:getChildrenOfType(currentNode, 'jmix:droppableContent')}" var="subchild"  varStatus="st">
                        wemEditToolbar.addData('${parsedId}','${functions:escapeJavaScript(subchild.unescapedName)}', '${url.context}');
                        </c:forEach>
                    });

                    window.top.addEventListener('jahia-copy', function (event) {
                        if (event.detail && event.detail.nodes) {
                            wemEditToolbar.handleJahiaCopyEvent('${parsedId}', event.detail.nodes);
                        }
                    });
                </script>
            </c:otherwise>
        </c:choose>
    </div>
</div>
