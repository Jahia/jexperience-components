<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="user" uri="http://www.jahia.org/tags/user" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="variantNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css"
                       resources="wem.dataTables.bootstrap.css,
                       picker.css,
                       flags.css,
                       angular-chart.css,
                       angular-ui-notification.min.css"/>

<template:addResources type="javascript"
                       resources="jquery-ui-1.12.1.min.js,
                       jquery.dataTables.min-1.10.5.js,
                       dataTables.bootstrap.js,
                       moment.min.js,
                       moment-timezone.js,
                       jstz.min.js,
                       underscore.js,
                       managers-utils.js,
                       Chart.js,
                       angular.js,
                       angular-animate.js,
                       angular-resource.js,
                       angular-md5.js,
                       angular-datatables.js,
                       angular-datatables.bootstrap.js,
                       angular-moment.min.js,
                       angular-underscore.js,
                       angular-route.js,
                       angular-chart.js,
                       angular-simple-logger.js,
                       angular-google-maps.js,
                       ui-bootstrap-tpls-0.13.2.min.js,
                       angular-ui-notification.min.js,
                       datepicker.js,
                       wem-services.js,
                       wem-modals.js,
                       i18n.js,
                       wem-directives.js,
                       condition.js,
                       property.js,
                       actions.js,
                       picker.js,
                       timeline.js,
                       dt-pager.js,
                       sortable.js"/>

<template:addResources type="css" resources="perso-opti-customEditEngine.css"/>
<template:addResources type="javascript" resources="manage-personalization-conditions.js"/>

<c:set var="variants" value="${jcr:getChildrenOfType(currentNode, 'wemnt:carouselItem')}" />

<script type="text/javascript">
    var currentDMFNodeUUID = "${currentNode.identifier}";
    var urlBase = '${url.base}';

    var variants = {};
    <c:forEach items="${variants}" var="variantNode">
    variants["${variantNode.identifier}"] = {
        "id": "${variantNode.identifier}",
        "name": "${functions:escapeJavaScript(variantNode.displayableName)}",
        "systemName": "${functions:escapeJavaScript(variantNode.unescapedName)}",
        "jsonFilter": ${functions:default(variantNode.properties['wem:jsonFilter'].string, 'null')},
        "tab": "${functions:default(variantNode.properties['wem:tab'].string, '')}"
    };
    </c:forEach>

    // NECESSARY TO FIX IE ISSUE RELATED TO IFRAME AND FOCUS ON INPUTS, QAMF-223, QAMF-453
    $(document).ready(function(){
        $("#ieFixInputs").focus().hide();
    })
</script>
<input id="ieFixInputs" type="text">
<div ng-app="managePersonalization">
    <div ng-controller="ManagePersonalizationCtrl" class="opttstpage">

        <div ng-if="toBeSaveVariants.length">

            <div class="group variants-table">
                <div class="selectModCont">
                    <label message-key="label.engineTab.dmfconditions.selectedVariant" class="fixLabelPos"/>
                </div>
                <div ui-sortable="sortableOptions" ng-model="toBeSaveVariants" class="sortableListContainer" ng-if="toBeSaveVariants">
                    <ul ng-repeat="variant in toBeSaveVariants | orderBy:'position'" class="list" ng-class="{'active':variant.id === toBeSaveVariant.id}">
                        <li class="item dragHandleContainer">
                            <i class="material-icons dragndrop">drag_handle</i>
                        </li>
                        <li class="item radioBtn">
                            <div ng-click="selectVariant(variant)"><i class="material-icons check">{{(variant.id === toBeSaveVariant.id) ? 'radio_button_checked' : 'radio_button_unchecked'}}</i></div>
                        </li>
                        <li class="item itemLarge">
                            {{variant.name}}
                        </li>
                    </ul>
                </div>
            </div>

            <form name="personalized" novalidate="" ng-show="toBeSaveVariant" class="botnFormPositionFix">
                <div class="group condBuilderMarginFix">
                    <div class="selectModCont">
                        <label message-key="label.engineTab.dmfconditions.conditions" class="fixLabelPos"></label>
                        <div class="btn-group tabsperscontsel" role="group">
                            <ul class="list checkboxList">
                                <li ng-repeat="tab in tabs" ng-click="selectTab(tab)" class="item radioBtn">
                                    <i class="material-icons check" ng-class="{'active':((tab === toBeSaveVariant.tab) && toBeSaveVariant.init) }">{{((tab === toBeSaveVariant.tab) && toBeSaveVariant.init) ? 'radio_button_checked' : 'radio_button_unchecked'}}</i>
                                    <div class="selectRadioLabel"><span message-key="label.engineTab.dmfconditions.type.{{tab}}"/></div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="row" ng-if="toBeSaveVariant.init">
                    <div class="groupaltforcond">
                        <a href="" class="btn btn-primary" aria-expanded="false" ng-click="toBeSaveVariant.init = false"><i class="fa fa-remove"></i> <span message-key="label.engineTab.dmfconditions.remove"></span></a>

                        <fieldset>
                            <input type="hidden" name="condition" ng-model="toBeSaveVariant.conditions[toBeSaveVariant.tab].type" required>
                            <div ng-class="{'has-error' : hasError('condition')}">
                                <condition ref="toBeSaveVariant.conditions[toBeSaveVariant.tab]"
                                           types="conditionTypes"
                                           form="personalized"
                                           disable-edition="toBeSaveVariant.disableEdition"/>
                            </div>
                        </fieldset>
                    </div>
                </div>
            </form>
        </div>
        <div ng-if="!toBeSaveVariants.length">
            <span message-key="label.engineTab.dmfconditions.noVariant"/>
        </div>
    </div>
</div>
