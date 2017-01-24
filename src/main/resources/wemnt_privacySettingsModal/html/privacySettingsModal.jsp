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

<c:choose>
    <c:when test="${currentNode.properties['wem:anonymizeProfile'].boolean or currentNode.properties['wem:activatePrivateBrowsing'].boolean}">
        <template:addResources type="css" resources="bootstrap.min.css"/>
        <template:addResources type="javascript" resources="jquery.min.js,bootstrap.min.js"/>

        <c:set var="cssClass" value="${currentNode.properties['wem:buttonCssClass'].string}"/>
        <c:set var="htmlId" value="${currentNode.properties['wem:buttonHtmlId'].string}"/>

        <fmt:message var="startPrivateBrowsingButton" key="wemnt_privacySettingsModal.wem_activatePrivateBrowsing.button.start"/>
        <c:if test="${not empty currentNode.properties['wem:startPrivateBrowsingButtonLabel']}">
            <c:set var="startPrivateBrowsingButton" value="${currentNode.properties['wem:startPrivateBrowsingButtonLabel'].string}"/>
        </c:if>
        <fmt:message var="stopPrivateBrowsingButton" key="wemnt_privacySettingsModal.wem_activatePrivateBrowsing.button.stop"/>
        <c:if test="${not empty currentNode.properties['wem:stopPrivateBrowsingButtonLabel']}">
            <c:set var="stopPrivateBrowsingButton" value="${currentNode.properties['wem:stopPrivateBrowsingButtonLabel'].string}"/>
        </c:if>

        <template:addResources>
            <script>
                var manageWemPrivacy = {
                    init: function() {
                        $('body').append($('#privacyModal_${currentNode.identifier}'));
                    },
                    initPrivacyButton: function () {
                        <c:if test="${currentNode.properties['wem:activatePrivateBrowsing'].boolean and not renderContext.editMode}">
                            $('#privateBrowsingError_${currentNode.identifier}').hide();
                            if (cxs.anonymousBrowsing) {
                                $('#privateBrowsing_${currentNode.identifier}').addClass('btn-success');
                                $('#privateBrowsing_${currentNode.identifier}').html('${functions:escapeJavaScript(stopPrivateBrowsingButton)}');
                            } else {
                                $('#privateBrowsing_${currentNode.identifier}').addClass('btn-danger');
                                $('#privateBrowsing_${currentNode.identifier}').html('${functions:escapeJavaScript(startPrivateBrowsingButton)}');
                            }
                        </c:if>
                        <c:if test="${currentNode.properties['wem:anonymizeProfile'].boolean}">
                            $('#anonymizeError_${currentNode.identifier}').hide();
                        </c:if>
                    }
                };

                $(document).ready(function () {
                    manageWemPrivacy.init();
                });
            </script>
        </template:addResources>

        <fmt:message var="privacyModalButtonLabel" key="wemnt_privacySettingsModal.button.privacy"/>
        <c:if test="${not empty currentNode.properties['wem:privacyModalButtonLabel']}">
            <c:set var="privacyModalButtonLabel" value="${currentNode.properties['wem:privacyModalButtonLabel'].string}"/>
        </c:if>

        <c:choose>
            <c:when test="${currentNode.properties['wem:buttonType'].string eq 'tagButton'}">
                <button type="button" class="${cssClass}" <c:if test="${not empty htmlId}"> id="${htmlId}"</c:if>
                        data-toggle="modal" data-target="#privacyModal_${currentNode.identifier}"
                        onclick="manageWemPrivacy.initPrivacyButton()">
                    ${privacyModalButtonLabel}
                </button>
            </c:when>
            <c:otherwise>
                <a href="#privacyModal_${currentNode.identifier}" <c:if test="${not empty htmlId}"> id="${htmlId}"</c:if>
                   data-toggle="modal" role="button" class="${cssClass}"
                   onclick="manageWemPrivacy.initPrivacyButton()">
                    ${privacyModalButtonLabel}
                </a>
            </c:otherwise>
        </c:choose>


        <div id="privacyModal_${currentNode.identifier}" class="modal fade" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                        <fmt:message var="privacyModalTitle" key="wemnt_privacySettingsModal.title.privacy"/>
                        <c:if test="${not empty currentNode.properties['wem:privacyModalTitle']}">
                            <c:set var="privacyModalTitle" value="${currentNode.properties['wem:privacyModalTitle'].string}"/>
                        </c:if>
                        <h4 class="modal-title">${privacyModalTitle}</h4>
                    </div>

                    <div class="modal-body">
                        <c:if test="${renderContext.editMode}">
                            <div class="alert alert-info">
                                <fmt:message key="wemnt_privacySettingsModal.info.buttonDisabled"/>
                            </div>
                        </c:if>

                        <p>
                            <fmt:message var="privacyModalInfo" key="wemnt_privacySettingsModal.info"/>
                            <c:if test="${not empty currentNode.properties['wem:privacyModalInfo']}">
                                <c:set var="privacyModalInfo" value="${currentNode.properties['wem:privacyModalInfo'].string}"/>
                            </c:if>
                            ${privacyModalInfo}
                        </p>

                        <c:if test="${currentNode.properties['wem:anonymizeProfile'].boolean}">
                            <fmt:message var="anonymizeProfileButtonLabel" key="wemnt_privacySettingsModal.wem_anonymizeProfile.button"/>
                            <c:if test="${not empty currentNode.properties['wem:anonymizeProfileButtonLabel']}">
                                <c:set var="anonymizeProfileButtonLabel" value="${currentNode.properties['wem:anonymizeProfileButtonLabel'].string}"/>
                            </c:if>
                            <button type="button" class="btn btn-default"
                                    onclick="wem.anonymizeProfile('#anonymizeError_${currentNode.identifier}')"
                                    <c:if test="${renderContext.editMode}">disabled</c:if>>
                                ${anonymizeProfileButtonLabel}
                            </button>
                            <div id="anonymizeError_${currentNode.identifier}" class="alert alert-danger">
                                <fmt:message key="wemnt_privacySettingsModal.wem_anonymizeProfile.error"/>
                            </div>
                        </c:if>

                        <c:if test="${currentNode.properties['wem:activatePrivateBrowsing'].boolean}">
                            <button id="privateBrowsing_${currentNode.identifier}"
                                    type="button" class="btn"
                                    onclick="wem.togglePrivateBrowsing('#privateBrowsingError_${currentNode.identifier}')"
                                    <c:if test="${renderContext.editMode}">disabled</c:if>>
                                <c:if test="${renderContext.editMode}">
                                    ${startPrivateBrowsingButton}
                                </c:if>
                            </button>
                            <div id="privateBrowsingError_${currentNode.identifier}" class="alert alert-danger">
                                <fmt:message key="wemnt_privacySettingsModal.wem_activatePrivateBrowsing.error"/>
                            </div>
                        </c:if>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal" aria-hidden="true">
                            <fmt:message key="label.close"/>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <c:if test="${renderContext.editMode}">
            <div class="alert alert-danger">
                <fmt:message key="wemnt_privacySettingsModal.error.noButtonToDisplay"/>
            </div>
        </c:if>
    </c:otherwise>
</c:choose>
