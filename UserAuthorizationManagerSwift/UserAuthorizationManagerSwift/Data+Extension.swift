//
//  Data+Extension.swift
//  Hess
//
//  Created by mini on 2023/3/28.
//

import Foundation

extension Data {
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            debugPrint("error:",error)
            return nil
        }
    }
    var htmlToString: String { htmlToAttributedString?.string ?? "" }
}
