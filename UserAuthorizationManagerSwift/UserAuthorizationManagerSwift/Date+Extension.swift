//
//  Date+Extension.swift
//  StrayAnimalsMap
//
//  Created by 陳列 on 2022/3/15.
//

import Foundation

extension Date {
    func toString(with dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: UserInfoManager.shared.localeType.rawValue)
        let result = formatter.string(from: self)
        return result
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}


