//
//  String+Extension.swift
//  smart
//
//  Created by 陳列 on 2022/6/15.
//

import Foundation
import UIKit
import CommonCrypto //MD5
import CryptoSwift
import CryptoKit



extension String {
    
    typealias downloadCompletion = (UIImage?)-> Void
    
    var md5: String {
        let digest = Insecure.MD5.hash(data: data(using: .utf8) ?? Data())
        return digest.map {
                    String(format: "%02hhx", $0)
                }.joined()
    }
    
    func textSize(font: UIFont ,maxSize: CGSize) -> CGSize {
        let dict = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let rect: CGRect = (self as NSString).boundingRect(with: maxSize,
                                                           options: NSStringDrawingOptions.truncatesLastVisibleLine,
                                                           attributes: dict as? [NSAttributedString.Key: Any],
                                                           context: nil)
        return rect.size
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func localizeString() -> String {
        let path = Bundle.main.path(forResource: UserInfoManager.shared.langType.rawValue, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func localizeString(with arguments: [CVarArg]) -> String {
        return String(format: self.localizeString(), locale: nil, arguments: arguments)
    }
    
    func string(with arguments: [CVarArg]) -> String {
        return String(format: self, locale: nil, arguments: arguments)
    }
    
    func toDate(with dateFormat: String) -> Date? {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: UserInfoManager.shared.localeType.rawValue)
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: date)
    }
    
    func change(from dateFormat: String, to changeFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: UserInfoManager.shared.localeType.rawValue)
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = changeFormat
        return dateFormatter.string(from: date)
    }
    
    func changeDate(changeDay: Int) -> String? {
        let gregorian = Calendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.dateFormat = "yyyy/MM-/dd HH:mm"
        guard let date = dateFormatter.date(from: self) else { return nil }
        let changeDate = gregorian.date(byAdding: .day, value: changeDay, to: date)
        let result = changeDate?.toString(with: "remindDateFormat".localizeString())
        return result
    }
    
    func downloaded(completion: @escaping downloadCompletion) {
        guard let url = URL(string: self) else { return }
        downloaded(from: url, completion: completion)
    }
    
    func downloaded(from url: URL, completion: @escaping downloadCompletion) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }

    func convertStringToDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    var stringDataImage: UIImage? {
        guard let dataDecoded = NSData(base64Encoded: self,options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: dataDecoded as Data)
    }
    
    func getLast(count: Int) -> String {
        if self.length >= count {
            let endIndex = self.index(self.endIndex, offsetBy: -count)
            return String(self.suffix(from: endIndex))
        } else {
            return self
        }
    }
    
    func removeR() -> String {
        return self.remove(word: "\n", replace: "")
    }
    
    //MARK: NSMutableAttributedString
    
    func specifyColorString(replaceStringArray: [String] ,replaceColor: UIColor, compareString: String) -> NSMutableAttributedString {
        let numbers = replaceStringArray
        let attributedString = NSMutableAttributedString(string: self)
        var text = NSString(string: self)
        for item in numbers {
            checkElement(checkNumber: item)
        }
        
        func checkElement(checkNumber: String) {
            let range = text.range(of: checkNumber)
            if range.length > 0 {
                text = text.replacingOccurrences(of: checkNumber, with: compareString, range: range) as NSString
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: replaceColor, range: range)
                checkElement(checkNumber: checkNumber)
            }
        }
        
        return attributedString
    }
    
    func numberColorString(replaceColor: UIColor) -> NSMutableAttributedString {
        let numbers = ["0","1","2","3","4","5","6","7","8","9"]
        let attributedString = NSMutableAttributedString(string: self)
        var text = NSString(string: self)
        for item in numbers {
            checkElement(checkNumber: item)
        }
        
        func checkElement(checkNumber: String) {
            let range = text.range(of: checkNumber)
            if range.length > 0 {
                text = text.replacingOccurrences(of: checkNumber, with: "a", range: range) as NSString
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: replaceColor, range: range)
                checkElement(checkNumber: checkNumber)
            }
        }
        
        return attributedString
    }
    
    func mutableAttributedString(with color: UIColor = .black, systemFontSize: CGFloat = FontSize.regular) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self,
                                         attributes: [
                                            .font: UIFont.systemFont(ofSize: systemFontSize),
                                            .foregroundColor: color
                                         ])
    }
    
    func remove(word: String, replace: String) -> String {
        return self.replacingOccurrences(of: word, with: replace)
    }
    
    
    var hasSymbols: Bool {
        let pattern = "[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]"
        let regex = try! NSRegularExpression(pattern: pattern)
        let isMatch = regex.firstMatch(in: self, range: NSMakeRange(0, self.utf16.count)) != nil
        return isMatch
    }
    
    var double: Double? {
        return Double(self)
    }
    
    var int: Int? {
        return Int(self)
    }
    
    var isContainsPhoneticCharacters: Bool {
        for scalar in self.unicodeScalars {
            if (scalar.value >= 12549 && scalar.value <= 12582) || (scalar.value == 12584 || scalar.value == 12585 || scalar.value == 19968) {
                return true
            }
        }
        return false
    }
    
    var aesEncrypt: String? {
        var result: String?
        do {
            let key = QrCodeParam.key
            let iv = QrCodeParam.iv
            let data: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            let aesEnc = try AES(key: key, iv: iv, padding: .pkcs7)
            let enc = try aesEnc.encrypt(data.bytes)
            
            let encData: Data = Data(bytes: enc, count: enc.count)
            result = encData.toHexString()
            
        } catch {
            print("encrypto error: \(error.localizedDescription)")
        }
        
        return result
    }
    
    func aesDecrypt() throws -> String? {
        var result: String?
        let key = QrCodeParam.key
        let iv = QrCodeParam.iv
        let data = Data(hex: self)
        let aesDec = try AES(key: key, iv: iv, padding: .pkcs7)
        let dec = try aesDec.decrypt(data.bytes)
        let decData: Data = Data(bytes: dec, count: dec.count)
        
        result = String(data: decData, encoding: .utf8)
        
        return result
    }
    
    var httpCheck: String? {
        let http = "http"
        let httpHead = "http://"
        return self.contains(http) ? self : httpHead+self
    }
    
    var length: Int {
        return self.utf16.count
    }
    
    var cgfloatValue: CGFloat? {
        let arrangeString = self.reduce("") { (result, char) in
            if !(result.contains(char) && char == ".") {
                return result + String(char)
            }
            return result
        }
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        guard let number = formatter.number(from: arrangeString) else { return nil }
        return CGFloat(truncating: number)
    }
}

extension StringProtocol {
    var htmlToAttributedString: NSAttributedString? {
        Data(utf8).htmlToAttributedString
    }
    
    var html2Sting: String {
        htmlToAttributedString?.string ?? ""
    }
}
