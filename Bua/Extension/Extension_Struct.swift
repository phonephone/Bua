//
//  Extension_Struct.swift
//  Bua
//
//  Created by Truk Karawawattana on 4/3/2567 BE.
//

import Foundation
import UIKit

// MARK: - String
extension String {
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    /// Decode a String from Base64. Returns nil if unsuccessful.
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8)
        else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func convertToAttributedFromHTML() -> NSAttributedString? {
        var attributedText: NSAttributedString?
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue]
        if let data = data(using: .unicode, allowLossyConversion: true), let attrStr = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            attributedText = attrStr
        }
        return attributedText
    }
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[0]\\d{9}$").evaluate(with: self)
    }
    
    //    "^[6-9]\\d{9}$"
    //    ^     #Match the beginning of the string
    //    [6-9] #Match a 6, 7, 8 or 9
    //    \\d   #Match a digit (0-9 and anything else that is a "digit" in the regex engine)
    //    {9}   #Repeat the previous "\d" 9 times (9 digits)
    //    $     #Match the end of the string
    
    var isValidPassword: Bool {
        let specialRegex = "!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~"
        return NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[\(specialRegex)])[A-Za-z\\d \(specialRegex)]{8,}").evaluate(with: self)
    }
    //All Special Character Regex "A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~"
    
    // "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$" --> (Minimum 8 characters at least 1 Alphabet and 1 Number)
    // "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,16}$" --> (Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}" --> (Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,10}" --> (Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character)
    
    var isValidOTP: Bool {
        //return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z]{6}").evaluate(with: self)
        return NSPredicate(format: "SELF MATCHES %@", "[0-9]{6}").evaluate(with: self)
    }
}

// MARK: - Bool
extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
    
    var stringValue: String {
        return self ? "1" : "0"
    }
}

// MARK: - Int
extension Int {
    var boolValue: Bool {
        return self != 0
    }
}

// MARK: - Date
extension Date {
    //    init(_ dateString:String) {
    //        let dateStringFormatter = DateFormatter()
    //        dateStringFormatter.locale = Locale(identifier: "en_US")
    //        dateStringFormatter.dateFormat = "yyyy-MM-dd"
    //        let date = dateStringFormatter.date(from: dateString)!
    //        self.init(timeInterval:0, since:date)
    //    }
}

// MARK: - DateFormatter
extension DateFormatter {
    //    static let appDateFormatStr: String = "d MMM yyyy"
    //    static let appDateWithTimeFormatStr: String = "dd MMM yyyy HH:mm"
    //    static let appMonthYearFormatStr: String = "MMMM yyyy"
    static let defaultLocale: String = "en_US_POSIX"
    
    static let serverFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.serverDateFormat
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let serverFormatterWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.serverDateWithTimeFormat
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let serverFormatterMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat.serverMonthYearFormat
        formatter.locale = Locale(identifier: defaultLocale)
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }()
    
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.locale = Locale(identifier: "Formatter_Locale".localized())//Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        //formatter.calendar = Calendar(identifier: .buddhist)
        return formatter
    }()
}


// MARK: - Bundle
extension Bundle {
    public var appName: String { getInfo("CFBundleName")  }
    public var displayName: String {getInfo("CFBundleDisplayName")}
    public var language: String {getInfo("CFBundleDevelopmentRegion")}
    public var identifier: String {getInfo("CFBundleIdentifier")}
    public var copyright: String {getInfo("NSHumanReadableCopyright")}
    public var appBuild: String { getInfo("CFBundleVersion") }
    public var appVersionLong: String { getInfo("CFBundleShortVersionString") }
    public var appVersionShort: String { getInfo("CFBundleShortVersion") }
    
    fileprivate func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "⚠️" }
}

// MARK: - UserDefaults
extension UserDefaults {
    
    func saveColor(_ value: UIColor?, forKey key: String) {
        
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
    }
    
    func loadcolor(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else {
            return nil
        }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
    }
}
