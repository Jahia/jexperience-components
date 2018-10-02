var manageWemPrivacy = {
    networkError : false,
    modelAlreadyOpen : false,
    createInstance: function(nodeIdentifier, config) {
        $('body').append($('#privacyModal_' + nodeIdentifier));

        var manageWemPrivacyInstance = {
            nodeIdentifier : nodeIdentifier,
            activatePrivateBrowsing : config.activatePrivateBrowsing,
            anonymizeProfile : config.anonymizeProfile,
            stopPrivateBrowsingButton : config.stopPrivateBrowsingButton,
            startPrivateBrowsingButton : config.startPrivateBrowsingButton,
            switchOnText : config.switchOnText,
            switchOffText : config.switchOffText,
            captiveModal : config.captiveModal,
            consentTypesUrl : config.consentTypesUrl,
            initPrivacyModal: function () {
                var vm = this;
                if (vm.activatePrivateBrowsing) {
                    $('#privateBrowsingError_' + vm.nodeIdentifier).hide();
                    var privacyBrowsingElement = $('#privateBrowsing_' + vm.nodeIdentifier);
                    if (cxs.anonymousBrowsing) {
                        privacyBrowsingElement.addClass('btn-success');
                        privacyBrowsingElement.html(vm.stopPrivateBrowsingButton);
                    } else {
                        privacyBrowsingElement.addClass('btn-danger');
                        privacyBrowsingElement.html(vm.startPrivateBrowsingButton);
                    }
                }
                if (vm.anonymizeProfile) {
                    $('#anonymizeError_' + vm.nodeIdentifier).hide();
                }
            },
            initConsents : function() {
                var vm = this;
                if (!window.cxs) {
                    console.info("wem-manage-privacy.initConsents: CXS object not yet available, registering callback");
                    if (window.wem) {
                        window.wem._registerCallback(function (digitalData) {
                            console.info("wem-manage-privacy.initConsents: loadCallback wemProfile=", window.cxs, " digitalData=", digitalData);
                            if (digitalData) {
                                vm.profileConsents = window.cxs.consents;
                                console.debug("wem-manage-privacy.initConsents: loadCallback vm.profileConsents=", vm.profileConsents);
                                vm.displayConsents();
                            } else {
                                console.error("wem-manage-privacy.initConsents: error loading digitalData, using fallback and not displaying consent popup !");
                                manageWemPrivacy.networkError = true;
                            }
                        });
                    }
                } else {
                    console.info("wem-manage-privacy.initConsents: wemProfile already available=", window.cxs, " networkError=", manageWemPrivacy.networkError);
                    vm.profileConsents = window.cxs.consents;
                    vm.displayConsents();
                }
            },
            onSuccess: function() {
                location.reload();
            },
            closeModal : function () {
                var vm = this;
                console.info("wem-manage-privacy.closeModal: Closing modal.");
                $('#privacyModal_' + vm.nodeIdentifier).modal('hide');
                manageWemPrivacy.modelAlreadyOpen = false;
            },
            openModal : function(mustInitConsents) {
                var vm = this;
                vm.initPrivacyModal();
                if (mustInitConsents) {
                    vm.initConsents();
                }
                $('#privacyModal_' + vm.nodeIdentifier).modal();
                manageWemPrivacy.modelAlreadyOpen = true;
            },
            updateCaptiveModal : function () {
                var vm = this;
                if (vm.captiveModal) {
                    console.info("wem-manage-privacy.updateCaptiveModal: captive modal is activated");
                    if (vm.consentsComplete() || manageWemPrivacy.networkError) {
                        console.info("privacyManager: consents are complete, we can activated the close buttons");
                        $('#closeDialogTopButton_' + vm.nodeIdentifier).show();
                        $('#incompleteConsentsWarning_' + vm.nodeIdentifier).hide();
                        $('#closeDialogLowerButton_' + vm.nodeIdentifier).show();
                    } else {
                        console.info("wem-manage-privacy.updateCaptiveModal: consents are not complete, we deactivate the close buttons");
                        $('#closeDialogLowerButton_' + vm.nodeIdentifier).hide();
                        $('#incompleteConsentsWarning_' + vm.nodeIdentifier).show();
                        $('#closeDialogTopButton_' + vm.nodeIdentifier).hide();
                    }
                } else {
                    console.info("wem-manage-privacy.updateCaptiveModal: captive modal is not activated");
                    $('#closeDialogTopButton_' + vm.nodeIdentifier).show();
                    $('#incompleteConsentsWarning_' + vm.nodeIdentifier).hide();
                    $('#closeDialogLowerButton_' + vm.nodeIdentifier).show();
                }
            },
            consentsComplete : function() {
                var vm = this;
                if (vm._storageAvailable('sessionStorage') && sessionStorage.personaId && sessionStorage.personaId != 'none') {
                    console.info("wem-manage-privacy.consentsComplete: PersonaId (="+sessionStorage.personaId+") detected, not checking consent completedness.");
                    return true;
                }
                if (vm.pageConsentTypes == null || $(vm.pageConsentTypes).length == 0) {
                    return true;
                }
                if ((vm.profileConsents == null) || ($(vm.profileConsents).length == 0)) {
                    return false;
                }
                var allConsentsHaveValues = true;
                $.each(vm.pageConsentTypes, function (i, consentType) {
                    if (consentType.activated && !vm.profileConsents[window.digitalData.scope + "/" + consentType.typeIdentifier]) {
                        allConsentsHaveValues = false;
                        console.info("wem-manage-privacy.consentsComplete: Missing a consent value for consent " + consentType.typeIdentifier + " in scope " + window.digitalData.scope);
                    } else {
                        if (!consentType.activated) {
                            console.info("wem-manage-privacy.consentsComplete: Not requiring consent value for consent " + consentType.typeIdentifier + " since it is deactivated.");
                        } else {
                            console.info("wem-manage-privacy.consentsComplete: We already have a value for consent " + consentType.typeIdentifier);
                        }
                    }
                });
                return allConsentsHaveValues;
            },
            displayConsents : function () {
                var vm=this;
                vm.pageConsentTypes=window.digitalData.page.consentTypes;
                if (manageWemPrivacy.networkError) {
                    $("#consentLoadNetworkError_" + vm.nodeIdentifier).show();
                    return;
                } else {
                    $("#consentLoadNetworkError_" + vm.nodeIdentifier).hide();
                }
                console.info("wem-manage-privacy.displayConsents: building UI for wemConsentTypes=", vm.pageConsentTypes);
                var consentsListElement = $("#consents_list_" + vm.nodeIdentifier);
                consentsListElement.empty();
                var nbConsentTypesDisplayed = 0;
                var processedConsentTypes = {};
                $.each(vm.pageConsentTypes, function (i, consentType) {
                    if (consentType.activated) {
                        consentsListElement.append(vm.createConsentSwitch(window.digitalData.scope, consentType.typeIdentifier, consentType.title, consentType.description));
                        nbConsentTypesDisplayed++;
                    } else {
                        console.info("wem-manage-privacy.displayConsents: Ignoring deactivated consent type " + consentType.typeIdentifier);
                    }
                    processedConsentTypes[window.digitalData.scope + "/" + consentType.typeIdentifier] = true;
                });
                // we must now calculate if we have any left over consents that were not coming from the page consents,
                // that might be consents coming from other UIs such as Form Factory forms.
                var nonPageConsents = [];
                $.each(vm.profileConsents, function (key, consent) {
                    if (!processedConsentTypes[key]) {
                        nonPageConsents.push(consent);
                    }
                });
                if (nonPageConsents.length > 0) {
                    console.debug("wem-manage-privacy.displayConsents: Found non page consents, loading consent types...");
                    $.getJSON(vm.consentTypesUrl)
                        .done(function (data, textStatus, jqXHR) {
                            console.info("wem-manage-privacy.displayConsents: Consent types loaded successfully.", data, textStatus, jqXHR);
                            vm.definedConsentTypes = data.consentTypes;
                            vm.activeContentLanguage = data.activeContentLanguage;
                            $.each(nonPageConsents, function (i, consent) {
                                if (consent.scope != window.digitalData.scope) {
                                    console.debug("wem-manage-privacy.displayConsents: Ignoring consent from scope " + consent.scope + " type:" + consent.typeIdentifier);

                                } else {
                                    var consentType = vm._getConsentType(vm.definedConsentTypes, consent.typeIdentifier);
                                    if (consentType && consentType.activated) {
                                        consentsListElement.append(vm.createConsentSwitch(window.digitalData.scope, consentType.identifier, consentType.title[vm.activeContentLanguage.key], consentType.description[vm.activeContentLanguage.key]));
                                        nbConsentTypesDisplayed++;
                                    } else {
                                        console.debug("wem-manage-privacy.displayConsents: Couldn't find defined consent type for consent with type ", consent.typeIdentifier);
                                    }
                                }
                            });
                            vm._finishDisplayConsents(nbConsentTypesDisplayed);
                        })
                        .fail(function (jqXHR, textStatus, errorThrown) {
                            console.error("wem-manage-privacy.displayConsents: Error loading consent types.", jqXHR, textStatus, errorThrown);
                        })
                } else {
                    // we have only page consents, we can continue processing normally
                    vm._finishDisplayConsents(nbConsentTypesDisplayed);
                }
            },
            _finishDisplayConsents : function (nbConsentTypesDisplayed) {
                var vm = this;
                if (nbConsentTypesDisplayed == 0) {
                    // we are not displaying any consent types, let's hide the tab.
                    console.info("wem-manage-privacy._finishDisplayConsents: Hiding consent tab since no consent types are available.");
                    $("a[href=\"#settings_"+ vm.nodeIdentifier + "\"]").tab('show');
                    $("a[href=\"#consents_"+ vm.nodeIdentifier + "\"]").hide();
                }
                vm.updateCaptiveModal();
                if (!vm.consentsComplete()) {
                    if (!manageWemPrivacy.modelAlreadyOpen) {
                        console.info("wem-manage-privacy._finishDisplayConsents: Incomplete profile consents, displaying popup modal for nodeIdentifier=" + vm.nodeIdentifier);
                        //show consent when initiate
                        //vm.openModal(false);
                    } else {
                        console.info("wem-manage-privacy._finishDisplayConsents: detected an already open modal, will not open this one.");
                    }
                }
            },
            createConsentSwitch : function (scope, typeIdentifier, title, description) {
                var vm = this;
                var status = null;
                var checked = false;
                var dataIndeterminate = true;
                if (vm.profileConsents && vm.profileConsents[scope + "/" + typeIdentifier]) {
                    status = vm.profileConsents[scope + "/" + typeIdentifier].status;
                    dataIndeterminate = status === null;
                    if (!dataIndeterminate) {
                        checked = (status === "GRANTED");
                    }
                }
                var switchOnRadioElement = $("<input/>", {type : "radio", name : typeIdentifier, id : typeIdentifier, autocomplete: false});
                var switchOnLabelElement = $("<label/>", {"class" : "btn btn-default btn-sm consent-switch-on"}).append(
                    switchOnRadioElement,
                    vm.switchOnText
                );
                switchOnLabelElement.click(function (event) {
                    manageWemPrivacyInstances[vm.nodeIdentifier].updateConsent(scope, typeIdentifier, true);
                });
                if (status === "GRANTED") {
                    switchOnLabelElement.addClass("active");
                }
                var switchOffRadioElement = $("<input/>", {type : "radio", name : typeIdentifier, id : typeIdentifier, autocomplete: false});
                var switchOffLabelElement = $("<label/>", {"class" : "btn btn-default btn-sm consent-switch-off"}).append(
                    switchOffRadioElement,
                    vm.switchOffText
                );
                switchOffLabelElement.click(function (event) {
                    manageWemPrivacyInstances[vm.nodeIdentifier].updateConsent(scope, typeIdentifier, false);
                });
                if (status === "DENIED") {
                    switchOffLabelElement.addClass("active");
                }
                return $("<div/>", { "class" : "row"}).append(
                    $("<div/>", {"class" : "btn-group consent-switch-container", "data-toggle" : "buttons"}).append(
                        switchOnLabelElement,
                        switchOffLabelElement
                    ),
                    $('<div/>', { "class" : 'switch-label'}).append(
                        $('<div/>', { "class" : 'switch-title' }).append(title),
                        $('<div/>', { "class" : 'switch-description'}).append(description)
                    )
                );
            },
            updateConsent : function (scope, typeIdentifier, granted) {
                var fqConsent = scope + "/" + typeIdentifier;
                console.info("wem-manage-privacy.updateConsent: Switch state of consent " + fqConsent + " granted=" + granted);
                var vm = this;
                var foundConsentType = null;
                $.each(vm.pageConsentTypes, function (i, consentType) {
                    if (consentType.typeIdentifier == typeIdentifier) {
                        foundConsentType = consentType;
                    }
                });
                if (!foundConsentType && vm.definedConsentTypes) {
                    foundConsentType = vm._getConsentType(vm.definedConsentTypes, typeIdentifier);
                }
                if (foundConsentType) {
                    vm.profileConsents = vm.profileConsents || {};
                    if (!vm.profileConsents[fqConsent]) {
                        vm.profileConsents[fqConsent] = {
                            typeIdentifier : typeIdentifier,
                            scope: scope
                        }
                    }
                    var nowDate = new Date();
                    var inTwoYearsDate = new Date();
                    inTwoYearsDate.setTime(nowDate.getTime()+2*365*24*60*60*1000); // 2 years expiration by default.
                    if (granted) {
                        vm.profileConsents[fqConsent].status = "GRANTED";
                        vm.profileConsents[fqConsent].statusDate = nowDate.toISOString();
                        vm.profileConsents[fqConsent].revokeDate = inTwoYearsDate.toISOString();
                    } else {
                        vm.profileConsents[fqConsent].status = "DENIED";
                        vm.profileConsents[fqConsent].statusDate = nowDate.toISOString();
                        vm.profileConsents[fqConsent].revokeDate = inTwoYearsDate.toISOString();
                    }
                    if (window.wem) {
                        var consentTypeEvent = {
                            scope: window.digitalData.scope,
                            eventType: "modifyConsent",
                            source:{
                                itemType: "page",
                                scope: window.digitalData.scope,
                                itemId: window.digitalData.page.pageInfo.pageID,
                                properties: window.digitalData.page
                            },
                            target: {
                                itemType:"consent",
                                scope: window.digitalData.scope,
                                itemId:typeIdentifier
                            },
                            properties: {
                                consent : vm.profileConsents[fqConsent]
                            }
                        };
                        window.wem.collectEvent(consentTypeEvent, function success(xhr) {
                            console.info("wem-manage-privacy.updateConsent: Consents are now:", vm.profileConsents);
                            window.cxs.consents = vm.profileConsents;
                            vm.updateCaptiveModal();
                            console.info("wem-manage-privacy.updateConsent: Consent event successfully sent.")
                        }, function error(xhr) {
                            console.error("wem-manage-privacy.updateConsent: Error while sending consent event.");
                        });
                    }
                }
            },
            _storageAvailable : function(storageType) {
                try {
                    var storage = window[storageType],
                        x = '__storage_test__';
                    storage.setItem(x, x);
                    storage.removeItem(x);
                    return true;
                } catch (e) {
                    return false;
                }
            },
            _getConsentType : function (consentTypes, consentTypeId) {
                if (!consentTypes) {
                    return null;
                }
                if (!consentTypeId) {
                    return null;
                }
                var foundConsentType = null;
                $.each(consentTypes, function (i, consentType) {
                    if (consentType.identifier == consentTypeId) {
                        console.debug("wem-manage-privacy._getConsentType: : Found consent type",consentType," definition for id=", consentTypeId);
                        foundConsentType = consentType;
                    }
                });
                return foundConsentType;
            }
        };

        manageWemPrivacyInstance.initConsents();

        return manageWemPrivacyInstance;
    }
};
