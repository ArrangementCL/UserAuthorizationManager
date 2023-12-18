//
//  UIApplication+Extension.swift
//  Hess
//
//  Created by mini on 2023/3/16.
//

import Foundation
import UIKit

extension UIApplication {
    var nowkeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}
