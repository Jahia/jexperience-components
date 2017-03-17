function customEditComponentPersoEngineGetAngularScope() {
    var frm = document.getElementById("conditionFrame");
    if (!frm) {
        return;
    }

    var fw = frm.contentWindow;
    if(!fw || !fw.angular || !fw.$ || fw.$(".ng-scope").length == 0) {
        return;
    }

    return fw.angular.element(fw.$(".ng-scope")[1]).scope();
}

function componentPersonalizationConditionsInit(data) {
    console.log(data);
    if (data.isNewNode) {
        console.log("IF");
        return $.parseHTML("<h1>Please click on save button to create your carousel then add carousel item and you will be able to access this panel!</h1>");
    }
    return $.parseHTML("<iframe id=\"conditionFrame\" width=\"100%\" height=\"100%\" frameborder='0' src=\"" + jahiaGWTParameters.contextPath + jahiaGWTParameters.servletPath + "/editframe/default/" + jahiaGWTParameters.lang + data.getPath() + ".wem-edit-engine-cpmnt-perso.html\"/>")[0];
}

function componentPersonalizationConditionsDoSave(node) {
    var angularScope = customEditComponentPersoEngineGetAngularScope();
    if (angularScope) {
        angularScope.save(node);
    }
}

function componentPersonalizationConditionsDoValidate(validation) {
    var angularScope = customEditComponentPersoEngineGetAngularScope();
    if (angularScope) {
        angularScope.validate(validation);
    }
}

function componentPersonalizationConditionsLanguageChange(data) { }

