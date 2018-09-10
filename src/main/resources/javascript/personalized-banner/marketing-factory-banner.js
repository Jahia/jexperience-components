mfb = {
    /**
     * This function is called by the dropdown selector button to update profile properties.
     *
     * @param {object} object
     */
    onChangeSelection: function (object) {
        var selectedValue = object.universe;

        if (selectedValue) {
            var selectionDropDown = document.getElementById('mfbSelectionDropdown');
            var ctaButtonText = document.getElementById('cta_button_text');

            selectionDropDown.textContent = selectedValue;
            ctaButtonText.textContent = object.ctaLabel;

            mfb.updateProfileProperties(selectedValue, object);
        }
    },

    /**
     * This function update profile properties.
     *
     * @param {string} universeValue
     * @param {object} object
     */
    updateProfileProperties: function (universeValue, object) {
        var universeId = document.getElementById('universeId').value;
        var pathURL = document.getElementById('pathURL').value;

        console.info('[MFB] Call event update profile properties');
        wem.ajax({
            url: encodeURI(pathURL + '.updateProfile.do'),
            type: 'POST',
            dataType: 'application/json',
            contentType: 'application/json',
            data: JSON.stringify(
                {
                    'profileId': cxs.profileId,
                    'sessionId': wem.sessionID,
                    'universeId': universeValue ? universeId : '',
                    'universeValue': universeValue ? universeValue : ''
                }
            ),
            success: function (data) {
                var result = JSON.parse(data.response);

                if (result.status === 'update-universe-property') {
                    console.info('[MFB] Profile properties successfully updated');

                    var bannerBackground = document.getElementById('main-banner-background');
                    bannerBackground.style.background = 'url(' + object.backgroundImageURL + ')';

                    mfb.changeWebsiteColor(object.webSiteHeaderTopColor,
                        object.webSiteHeaderBottomColor,
                        object.webSiteFooterTopColor,
                        object.webSiteFooterBottomColor);
                    mfb.changeButtonColor(object.ctaStartColor,
                        object.ctaEndColor,
                        object.ctaTextColor,
                        object.callToActionURL,
                        object.ctaLabel);
                } else {
                    console.error('[MFB] Could not update profile properties');
                }
            },
            error: function (err) {
                console.error('[MFB] Could not update profile properties', err);
            }
        });
    },

    /**
     * This function change the website header and footer background color.
     *
     * @param {string} headerTopBGColor
     * @param {string} headerBottomBGColor
     * @param {string} footerTopBGColor
     * @param {string} FooterBottomBGColor
     */
    changeWebsiteColor: function (headerTopBGColor, headerBottomBGColor, footerTopBGColor, FooterBottomBGColor) {
        var headerTop = document.getElementsByClassName('blog-topbar');
        var headerBottom = document.getElementsByClassName('navbar');
        var footerTop = document.getElementsByClassName('footer');
        var footerBottom = document.getElementsByClassName('copyright');

        if (headerTop.length > 0) headerTop[0].style.backgroundColor = headerTopBGColor;
        if (headerBottom.length > 0) headerBottom[0].style.backgroundColor = headerBottomBGColor;
        if (footerTop.length > 0) footerTop[0].style.backgroundColor = footerTopBGColor;
        if (footerBottom.length > 0) footerBottom[0].style.backgroundColor = FooterBottomBGColor;
    },

    /**
     * This function change the CTA button color
     *
     * @param {string} ctaStartColor
     * @param {string} ctaEndColor
     * @param {string} ctaTextColor
     * @param {string} callToActionURL
     * @param {string} ctaLabel
     */
    changeButtonColor: function (ctaStartColor, ctaEndColor, ctaTextColor, callToActionURL, ctaLabel) {
        var ctaButtonColor = document.getElementById('cta_button');

        ctaButtonColor.style.visibility = !ctaLabel ? 'hidden' : 'visible';
        ctaButtonColor.setAttribute('href', callToActionURL);

        if (ctaStartColor && ctaEndColor) {
            ctaButtonColor.style.background = 'linear-gradient(45deg, ' + ctaStartColor + ' 30%, ' + ctaEndColor + ' 90%)';
        } else if (ctaStartColor) {
            ctaButtonColor.style.background = 'linear-gradient(45deg, ' + ctaStartColor + ' 30%, ' + ctaStartColor + ' 90%)';
        } else if (ctaEndColor) {
            ctaButtonColor.style.background = 'linear-gradient(45deg, ' + ctaEndColor + ' 30%, ' + ctaEndColor + ' 90%)';
        } else {
            ctaButtonColor.style.background = 'linear-gradient(45deg, #FE6B8B 30%, #FF8E53 90%)';
        }

        if (ctaTextColor === 'dark') {
            ctaButtonColor.classList.add('cta-text-color-dark');
            ctaButtonColor.classList.remove('cta-text-color-light');
        } else if (ctaTextColor === 'light') {
            ctaButtonColor.classList.add('cta-text-color-light');
            ctaButtonColor.classList.remove('cta-text-color-dark');
        }
    }
};

window.onload = function () {
    var webSiteHeaderTopColor = document.getElementById('webSiteHeaderTopColor').value;
    var webSiteHeaderBottomColor = document.getElementById('webSiteHeaderBottomColor').value;
    var webSiteFooterTopColor = document.getElementById('webSiteFooterTopColor').value;
    var webSiteFooterBottomColor = document.getElementById('webSiteFooterBottomColor').value;

    mfb.changeWebsiteColor(webSiteHeaderTopColor,
        webSiteHeaderBottomColor,
        webSiteFooterTopColor,
        webSiteFooterBottomColor);
};
