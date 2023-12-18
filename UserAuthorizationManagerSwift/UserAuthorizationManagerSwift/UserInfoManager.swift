//
//  UserInfoManager.swift
//  Hess
//
//  Created by mini on 2023/4/6.
//

import Foundation

class UserInfoManager {
    
    static let shared: UserInfoManager = UserInfoManager()
    
    // user
    var localeType: LocaleType = .tw
    var langType: LangType = .traditionalChinese
    
    var authToken = ""
    var pushToken = ""
    var userDeviceId = ""
}

extension UserInfoManager {

}
