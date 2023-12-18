//
//  Common.swift
//  smart
//
//  Created by Person Zhang on 2022/6/27.
//

import Foundation

let appVersion = String(format: "%@(%@)", Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! CVarArg, Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! CVarArg)
var acceptType = "accept"
var acceptData = "text/plain"
var contentType = "content-type"
var contentJosn = "application/json"
var authType = "Authorization"
var langType = "Accept-Language"

var topPadding: CGFloat = 0.0
var bottomPadding: CGFloat = 0.0
var leftPadding: CGFloat = 0.0
var rightPadding: CGFloat = 0.0

public enum LangType: String {
    case english = "en"
    case traditionalChinese = "zh-Hant"
}

public enum LocaleType: String {
    case en = "en_TW"
    case tw = "zh_Hant_TW"
}

public enum CRUDStatus {
    case create, read ,update, delete
}

struct MediaType {
    static let png = ".png"
    static let jpg = ".jpg"
}

struct CornerRadiusSize {
    static let thin: CGFloat = 3.0
    static let small: CGFloat = 5.0
    static let medium: CGFloat = 7.0
    static let large: CGFloat = 10.0
    static let XLarge: CGFloat = 15.0
    static let huge: CGFloat = 20.0
}

struct BorderWidthSize {
    static let ultarLight: CGFloat = 0.3
    static let thin: CGFloat = 0.5
    static let regular: CGFloat = 1.0
    static let medium: CGFloat = 2.0
    static let bold: CGFloat = 3.0
}

struct FontSize {
    static let large: CGFloat = 24.0
    static let regular: CGFloat = 17.0
    static let small: CGFloat = 14.0
}

struct QrCodeParam {
    static let key = "XCLMzbWx4wA4AMOPvfyt9Vt7d9icyNEA"
    static let iv = "fedcba9876543210"
}
