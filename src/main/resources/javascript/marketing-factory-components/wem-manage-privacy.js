var manageWemPrivacy = {
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
                    console.info("privacyManager: CXS object not yet available, registering callback");
                    if (window.wem) {
                        window.wem.registerCallbacks(function (digitalData) {
                            console.info("privacyManager: wemProfile=", window.cxs);
                            vm.consents = window.cxs.consents;
                            vm.displayConsents();
                        });
                    }
                } else {
                    console.info("privacyManager: wemProfile already available=", window.cxs);
                    vm.consents = window.cxs.consents;
                    vm.displayConsents();
                }
            },
            onSuccess: function() {
                location.reload();
            },
            closeModal : function () {
                var vm = this;
                console.info("privacyManager: Closing modal.");
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
                    console.info("privacyManager: captive modal is activated");
                    if (vm.consentsComplete()) {
                        console.info("privacyManager: consents are complete, we can activated the close buttons");
                        $('#closeDialogTopButton_' + vm.nodeIdentifier).show();
                        $('#incompleteConsentsWarning_' + vm.nodeIdentifier).hide();
                        $('#closeDialogLowerButton_' + vm.nodeIdentifier).show();
                    } else {
                        console.info("privacyManager: consents are not complete, we deactivate the close buttons");
                        $('#closeDialogLowerButton_' + vm.nodeIdentifier).hide();
                        $('#incompleteConsentsWarning_' + vm.nodeIdentifier).show();
                        $('#closeDialogTopButton_' + vm.nodeIdentifier).hide();
                    }
                } else {
                    console.info("privacyManager: captive modal is not activated");
                    $('#closeDialogTopButton_' + vm.nodeIdentifier).show();
                    $('#incompleteConsentsWarning_' + vm.nodeIdentifier).hide();
                    $('#closeDialogLowerButton_' + vm.nodeIdentifier).show();
                }
            },
            consentsComplete : function() {
                var vm = this;
                if (vm.consentTypes == null || $(vm.consentTypes).length == 0) {
                    return true;
                }
                if ((vm.consents == null) || ($(vm.consents).length == 0)) {
                    return false;
                }
                var allConsentsHaveValues = true;
                $.each(vm.consentTypes, function (i, consentType) {
                    if (!vm.consents[consentType.typeIdentifier]) {
                        allConsentsHaveValues = false;
                        console.info("Missing a consent value for consent " + consentType.typeIdentifier);
                    }
                });
                return allConsentsHaveValues;
            },
            displayConsents : function () {
                var vm=this;
                vm.consentTypes=window.digitalData.page.consentTypes;
                console.info("privacyManager: building UI for wemConsentTypes=", vm.consentTypes);
                $("#consents_list_" + vm.nodeIdentifier).empty();
                $.each(vm.consentTypes, function (i, consentType) {
                    $("#consents_list_" + vm.nodeIdentifier).append(vm.createConsentSwitch(consentType.typeIdentifier, consentType.title, consentType.description));
                    $("[name='"+consentType.typeIdentifier+"']").bootstrapSwitch({
                        size : 'mini',
                        onText : vm.switchOnText,
                        offText : vm.switchOffText,
                        labelText : '',
                        labelWidth : 0,
                        onSwitchChange : function (event, state) {
                            manageWemPrivacyInstances[vm.nodeIdentifier].updateConsent(consentType.typeIdentifier, state);
                        }
                    });
                });
                vm.updateCaptiveModal();
                if (!vm.consentsComplete()) {
                    if (!manageWemPrivacy.modelAlreadyOpen) {
                        console.info("privacyManager: Incomplete profile consents, displaying popup modal for nodeIdentifier=" + vm.nodeIdentifier);
                        vm.openModal(false);
                    } else {
                        console.info("privacyManager: detected an already open modal, will not open this one.");
                    }
                }
            },
            createConsentSwitch : function (typeIdentifier, title, description) {
                var vm = this;
                var grant = null;
                var checked = false;
                var dataIndeterminate = true;
                if (vm.consents && vm.consents[typeIdentifier]) {
                    grant = vm.consents[typeIdentifier].grant;
                    dataIndeterminate = grant === null;
                    if (!dataIndeterminate) {
                        checked = (grant === "GRANT");
                    }
                }
                return $("<div/>", {class: 'row'}).append(
                        $('<input/>', {
                            id : 'consent_checkbox_' + typeIdentifier + "_" + vm.nodeIdentifier,
                            type: 'checkbox',
                            name: typeIdentifier,
                            "data-indeterminate": dataIndeterminate,
                            checked: checked
                        }),
                        $('<div/>', { class : 'switch-label'}).append(
                            $('<div/>', { class : 'switch-title' }).append(title),
                            $('<div/>', { class : 'switch-description'}).append(description)
                        )
                    );
            },
            updateConsent : function (typeIdentifier, granted) {
                console.info("privacyManager: Switch state of consent " + typeIdentifier + " granted=" + granted);
                var vm = this;
                var foundConsentType = null;
                $.each(vm.consentTypes, function (i, consentType) {
                    if (consentType.typeIdentifier == typeIdentifier) {
                        foundConsentType = consentType;
                    }
                });
                if (foundConsentType) {
                    vm.consents = vm.consents || {};
                    if (!vm.consents[typeIdentifier]) {
                        vm.consents[typeIdentifier] = {
                            typeIdentifier : typeIdentifier
                        }
                    }
                    var nowDate = new Date();
                    var inTwoYearsDate = new Date();
                    inTwoYearsDate.setTime(nowDate.getTime()+2*365*24*60*60*1000); // 2 years expiration by default.
                    if (granted) {
                        vm.consents[typeIdentifier].grant = "GRANT";
                        vm.consents[typeIdentifier].grantDate = nowDate.toISOString();
                        vm.consents[typeIdentifier].revokeDate = inTwoYearsDate.toISOString();
                    } else {
                        vm.consents[typeIdentifier].grant = "DENY";
                        vm.consents[typeIdentifier].grantDate = nowDate.toISOString();
                        vm.consents[typeIdentifier].revokeDate = inTwoYearsDate.toISOString();
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
                                consent : vm.consents[typeIdentifier]
                            }
                        };
                        window.wem.collectEvent(consentTypeEvent, function success(xhr) {
                            console.info("privacyManager: Consents are now:", vm.consents);
                            window.cxs.consents = vm.consents;
                            vm.updateCaptiveModal();
                            console.info("privacyManager: Consent event successfully sent.")
                        }, function error(xhr) {
                            console.error("privacyManager: Error while sending consent event.");
                        });
                    }
                }
            }

        };

        manageWemPrivacyInstance.initConsents();

        return manageWemPrivacyInstance;
    }
};
