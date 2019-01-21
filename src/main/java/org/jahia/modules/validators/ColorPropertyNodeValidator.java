/*
 * ==========================================================================================
 * =                            JAHIA'S ENTERPRISE DISTRIBUTION                             =
 * ==========================================================================================
 *
 *                                  http://www.jahia.com
 *
 * JAHIA'S ENTERPRISE DISTRIBUTIONS LICENSING - IMPORTANT INFORMATION
 * ==========================================================================================
 *
 *     Copyright (C) 2002-2019 Jahia Solutions Group. All rights reserved.
 *
 *     This file is part of a Jahia's Enterprise Distribution.
 *
 *     Jahia's Enterprise Distributions must be used in accordance with the terms
 *     contained in the Jahia Solutions Group Terms & Conditions as well as
 *     the Jahia Sustainable Enterprise License (JSEL).
 *
 *     For questions regarding licensing, support, production usage...
 *     please contact our team at sales@jahia.com or go to http://www.jahia.com/license.
 *
 * ==========================================================================================
 */
package org.jahia.modules.validators;

import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.decorator.validation.JCRNodeValidator;

import javax.validation.constraints.Pattern;

public class ColorPropertyNodeValidator implements JCRNodeValidator {
    private static final String COLOR_NAMES = "aliceblue|antiquewhite|aqua|aquamarine|azure|beige|bisque|black|blanchedalmond|blue|blueviolet|brown|burlywood|cadetblue|chartreuse|chocolate|coral|cornflowerblue|cornsilk|crimson|cyan|darkblue|darkcyan|darkgoldenrod|darkgray|darkgreen|darkkhaki|darkmagenta|darkolivegreen|darkorange|darkorchid|darkred|darksalmon|darkseagreen|darkslateblue|darkslategray|darkturquoise|darkviolet|deeppink|deepskyblue|dimgray|dodgerblue|firebrick|floralwhite|forestgreen|fuchsia|gainsboro|ghostwhite|gold|goldenrod|gray|green|greenyellow|honeydew|hotpink|indianred|indigo|ivory|khaki|lavender|lavenderblush|lawngreen|lemonchiffon|lightblue|lightcoral|lightcyan|lightgoldenrodyellow|lightgreen|lightgrey|lightpink|lightsalmon|lightseagreen|lightskyblue|lightslategray|lightsteelblue|lightyellow|lime|limegreen|linen|magenta|maroon|mediumaquamarine|mediumblue|mediumorchid|mediumpurple|mediumseagreen|mediumslateblue|mediumspringgreen|mediumturquoise|mediumvioletred|midnightblue|mintcream|mistyrose|moccasin|navajowhite|navy|oldlace|olive|olivedrab|orange|orangered|orchid|palegoldenrod|palegreen|paleturquoise|palevioletred|papayawhip|peachpuff|peru|pink|plum|powderblue|purple|red|rosybrown|royalblue|saddlebrown|salmon|sandybrown|seagreen|seashell|sienna|silver|skyblue|slateblue|slategray|snow|springgreen|steelblue|tan|teal|thistle|tomato|turquoise|violet|wheat|white|whitesmoke|yellow|yellowgreen";
    private JCRNodeWrapper node;

    public ColorPropertyNodeValidator(JCRNodeWrapper node) {
        this.node = node;
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getCtaStartColor() {
        return node.getPropertyAsString("ctaStartColor");
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getCtaEndColor() {
        return node.getPropertyAsString("ctaEndColor");
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getWebSiteHeaderTopColor() {
        return node.getPropertyAsString("webSiteHeaderTopColor");
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getWebSiteHeaderBottomColor() {
        return node.getPropertyAsString("webSiteHeaderBottomColor");
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getWebSiteFooterTopColor() {
        return node.getPropertyAsString("webSiteFooterTopColor");
    }

    @Pattern(regexp = "^(" + COLOR_NAMES + "|#[0-9A-F]{3}|#[0-9A-F]{6})$",
            flags = Pattern.Flag.CASE_INSENSITIVE,
            message = "{wemnt_personalizedBannerItem.ctaStartColor.error.message}")
    private String getWebSiteFooterBottomColor() {
        return node.getPropertyAsString("webSiteFooterBottomColor");
    }

}
