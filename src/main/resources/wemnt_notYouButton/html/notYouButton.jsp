<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:url value="${url.context}/cms/logout?redirect=${url.mainResource}" var="logoutUrl"/>
<template:addResources>
    <script type="text/javascript">
        function switchToNewSession(){
            //Invalidate the current session
            wem.invalidateSessionAndProfile();
            //Reload context after the clear
            wem.loadContext(false, true);
            document.getElementById("wem_notYou_feedbackMessage").style.display="block";
        }
    </script>
</template:addResources>
<template:addResources type="css" resources="bootstrap.min.css"/>
<template:addResources type="javascript" resources="jquery.min.js,bootstrap.min.js"/>

<c:set var="cssClass" value="${currentNode.properties['wem:notYouButtonCssClass'].string}"/>
<c:set var="htmlId" value="${currentNode.properties['wem:notYouButtonHtmlId'].string}"/>

<fmt:message var="notYouButtonLabel" key="wemnt_notYouButton.label"/>
<c:if test="${not empty currentNode.properties['wem:notYouButtonLabel']}">
    <c:set var="notYouButtonLabel" value="${currentNode.properties['wem:notYouButtonLabel'].string}"/>
</c:if>
<c:if test="${renderContext.user.username eq 'guest' or renderContext.editMode}">
    <button type="button" class="${cssClass}" <c:if test="${not empty htmlId}"> id="${htmlId}"</c:if>
            onclick="switchToNewSession()" <c:if test="${renderContext.editMode}">disabled="disabled"</c:if>>
        ${notYouButtonLabel}
    </button>
    <div id="wem_notYou_feedbackMessage" style="display:none"><fmt:message key="wemnt_notYouButton.feedback"/></div>
</c:if>