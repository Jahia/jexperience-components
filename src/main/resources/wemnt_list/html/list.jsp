<%@ page import="org.jahia.modules.jexperience.admin.Constants" %>
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
<c:set var="variants" value="${jcr:getChildrenOfType(currentNode, 'jmix:droppableContent')}"/>

<div class="container">
    <c:if test="${renderContext.editMode}">
        <div class=" button-placeholder x-component" style="overflow: visible;">
        <span onmouseover="parent.disableGlobalSelection(true)"
              onmouseout="parent.disableGlobalSelection(false)"
              onclick="window.top.jExperienceHook.open('wem-edit-engine-cpmnt-perso', '${currentNode.path}')"
        >
            <img style="width: 16px; height: 16px"
                 src="<c:url value="/modules/jexperience/images/icons/personalization.svg"/>">
            <fmt:message key="wem.label.edit.personalization"/>
        </span>
        </div>
    </c:if>

    <div id="listTitle_${currentNode.identifier}">
        <h2>${title}</h2>
    </div>
    <div id="personalizedList_${currentNode.identifier}">
        <c:choose>
            <c:when test="${!renderContext.editMode}">
                <ol id="listItem_${currentNode.identifier}">
                    <c:choose>
                        <c:when test="${wem:isPersonalizationActive(currentNode)}">
                            <script type="text/javascript">
                                wemHasServerSideRendering = true;
                            </script>

                            <c:set var="jsonPersonalization" value="${wem:getWemPersonalizationRequest(currentNode)}"/>

                            <jx:ssrExperience id="${currentNode.identifier}"  multiple="true">
                                <c:forEach items="${variants}" var="variant">
                                    <jx:ssrVariant id="${variant.identifier}" variant-experience="${currentNode.identifier}">
                                        <template:module node="${variant}"/>
                                    </jx:ssrVariant>
                                </c:forEach>
                            </jx:ssrExperience>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${variants}" var="variant">
                                <template:module node="${variant}"/>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ol>
            </c:when>
            <c:otherwise>
                <ol id="listItem_${currentNode.identifier}">
                    <c:forEach items="${variants}" var="droppableContent">
                        <template:module node="${droppableContent}" editable="true"/>
                    </c:forEach>
                </ol>

                <c:set var="parsedId" value="${fn:replace(currentNode.identifier,'-','_')}"/>
                <div id="wemToolbarJahiaButtons${parsedId}">
                    <template:module path="*"/>
                </div>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        <c:forEach items="${variants}" var="subchild"  varStatus="st">
                        wemEditToolbar.addData('${parsedId}', '${functions:escapeJavaScript(subchild.unescapedName)}', '${url.context}');
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
