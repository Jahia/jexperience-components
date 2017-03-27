<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<jcr:nodeProperty var="image" node="${currentNode}" name="image"/>
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="caption" value="${currentNode.properties['caption'].string}"/>
<c:if test="${! empty image.node.url}">
    <c:url var="imageUrl" value="${image.node.url}" context="/"/>
</c:if>
<img src="${imageUrl}" alt="${fn:escapeXml(image.node.displayableName)}" style="<c:if test="${renderContext.editMode}">height:500px; </c:if> width: 100%;"/>
<c:if test="${not empty title or not empty caption}">
    <div class="carousel-caption">
        <c:if test="${not empty title}">
            <h3>${title}</h3>
        </c:if>
        <br />
        <c:if test="${not empty caption}">
            <p>${caption}</p>
        </c:if>
    </div>
</c:if>
