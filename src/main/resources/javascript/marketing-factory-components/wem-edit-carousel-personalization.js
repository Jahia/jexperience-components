function customEditCarouselPersoEngineGetAngularScope () {
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

function carouselPersonalizationConditionsInit(data) {
    console.log(data);
    if (data.isNewNode) {
        console.log("IF");
        return $.parseHTML("<h1>Please click on save button to create your carousel then add carousel item and you will be able to access this panel!</h1>");
    }
    return $.parseHTML("<iframe id=\"conditionFrame\" width=\"100%\" height=\"100%\" frameborder='0' src=\"" + jahiaGWTParameters.contextPath + jahiaGWTParameters.servletPath + "/editframe/default/" + jahiaGWTParameters.lang + data.getPath() + ".wem-edit-engine-carousel-perso.html\"/>")[0];
}

function carouselPersonalizationConditionsDoSave(node) {
    var angularScope = customEditCarouselPersoEngineGetAngularScope();
    if(angularScope) {
        angularScope.save(node)
    }
}

function carouselPersonalizationConditionsDoValidate(validation) {
    var angularScope = customEditCarouselPersoEngineGetAngularScope();
    if(angularScope) {
        angularScope.validate(validation)
    }
}

function carouselPersonalizationConditionsLanguageChange(data) {
}

