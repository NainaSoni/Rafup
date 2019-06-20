//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    public func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func isBlankString()-> Bool {
        return self.trim().count == 0
    }
    
    //: ### SHA String
    public var sha512Hex: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        if let data = self.data(using: String.Encoding.utf8) {
            let value =  data as NSData
            CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
            
        }
        var digestHex = ""
        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
            digestHex += String(format: "%02X", digest[index]) //02x
        }
        
        return digestHex
    }
    
    public var sha512: [UInt8] {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        let data = self.data(using: String.Encoding.utf8 , allowLossyConversion: true)
        let value =  data! as NSData
        CC_SHA512(value.bytes, CC_LONG(value.length), &digest)
        return digest
    }
    
    public var sha512Base64: String {
        let digest = NSMutableData(length: Int(CC_SHA512_DIGEST_LENGTH))!
        if let data = self.data(using: String.Encoding.utf8) {
            
            let value =  data as NSData
            let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: digest.length)
            CC_SHA512(value.bytes, CC_LONG(data.count), uint8Pointer)
            
        }
        return digest.base64EncodedString(options: NSData.Base64EncodingOptions([]))
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    public func getDateStringFromTimeStamp(dateformat:String)-> String {
        let timestamp=Double(self)
        
        
        guard timestamp != nil else {
            return "\(Date())"
        }
        
        let date = Date(timeIntervalSince1970: Double(self)!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = dateformat//"yyyy-MM-dd HH:mm"          //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
        
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    // MARK:- String class extension for capitalizing first character
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    public func substring(_ from: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: from)])
    }
    
    public func startWith(_ find: String) -> Bool {
        return self.hasPrefix(find)
    }
    
    public func equals(_ find: String) -> Bool {
        return self == find
    }
    
    public func contains(_ find: String) -> Bool {
        if let _ = self.range(of: find) {
            return true
        }
        return false
    }
    
    public var length: Int {
        return self.count
    }
    
    public var str: NSString {
        return self as NSString
    }
    public var pathExtension: String {
        return str.pathExtension 
    }
    public var lastPathComponent: String {
        return str.lastPathComponent 
    }
    
    public func boolValue() -> Bool? {
        var returnValue:Bool = false
        let falseValues = ["false", "no", "0"]
        let lowerSelf = self.lowercased()
        
        if falseValues.contains(lowerSelf) {
            returnValue =  false
        } else {
            returnValue = true
        }
        return returnValue
    }
    
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    public var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    public var IntValue: Int {
        return Int((self as NSString).intValue)
    }
    
    func URLEncodedString() -> String {
        let customAllowedSet =  CharacterSet.urlQueryAllowed
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return escapedString ?? ""
    }
    
    public func makeURL() -> URL? {
        
        let trimmed = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = URL(string: trimmed ?? "") else {
            return nil
        }
        return url
    }
    
    static func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: String.CompareOptions.literal, range: nil)
    }
    static func widthForText(_ text: String, font: UIFont, height: CGFloat) -> CGFloat {
        
        let rect = NSString(string: text).boundingRect(with: CGSize(width:  CGFloat(MAXFLOAT), height:height), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.width)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    

    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func removeHtmlFromString() -> String {
        
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    public static func nullCheck(string: String?) -> String {
        
        if string == nil {
            return ""
        } else {
            return string!
        }
    }
    
    public func removeStringTill(occurence:String) -> String  {
        if let range = self.range(of: occurence) {
            let secondPart = self[range.upperBound...]
            print(secondPart)
            return String(secondPart)
        }
        return self
    }
    
    /// Convert String to Date
    public func convertToDate(dateFormat formatType: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType // Your date format
        let serverDate = dateFormatter.date(from:self) // according to date format your date string
        return serverDate
    }
    
    /// Diviation calculation
    public func convertToSeconds(dateFormat formatType: String) -> Int {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType
        
        let date: Date = dateFormatter.date(from: self)!
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: date)
        let hour = comp.hour
        let minute = comp.minute
        // let sec = comp.second
        
        let totalSeconds = ((hour! * 60) * 60) + (minute! * 60) //+ sec!
        
        return totalSeconds
    }
    
    /// To Show the Date in String format
    public func convertToShowFormatDate(dateFormatForInput inputformat: String, dateFormatForOutput outformat: String) -> String {
        
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = inputformat //Your date format
        
        let serverDate: Date = dateFormatterDate.date(from: self)! //according to date format your date string
        
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = outformat //Your New Date format as per requirement change it own
        let newDate: String = dateFormatterString.string(from: serverDate) //pass Date here
        print(newDate) // New formatted Date string
        
        return newDate
    }
    
    public func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

/// To Show Memory address of variable
extension String {
    static func pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "nil" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}
