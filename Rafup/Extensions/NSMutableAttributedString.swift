//
//  NSMutableAttributedString.swift
//  VIsaSelect
//
//  Created by Ashish on 13/04/18.
//  Copyright © 2018 Krishan Kumar. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    
    /* let formattedString = NSMutableAttributedString()
     formattedString.bold("Bold Text").normal(" Normal Text ").bold("Bold Text")
     let lbl = UILabel()
     lbl.attributedText = formattedString
     */
    // MARK: - Get Bold And Regular String Attributed
    /**
     Here is a neat way to make a combination of bold and normal texts
     
     - Parameters:
        - text : Input String
        - size : font size
     
     - Returns:  attrbuted string with bold and regular font.
     */
    @discardableResult func bold(_ text: String, _ size:CGFloat = 14) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Arial-BoldMT", size: size)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }

    @discardableResult func bold(_ text: String, _ font:UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
    
    /* let formattedString = NSMutableAttributedString()
     formattedString.setBorderToText(String Test, 5 , UIColour.red, UIColour.yellow, 15)
     let lbl = UILabel()
     lbl.attributedText = formattedString
     */
    // MARK: - Set Border to text
    /**
     Here is a neat way to add border to text with color
     
     - Parameters:
        - text : Border text
        - borderWidth : width of border
     
     - Returns: attrbuted string with border text.
     
     */
    @discardableResult func setBorderToText(_ text: String, _ borderWidth:CGFloat, _ borderColour:UIColor, _ textColour:UIColor, _ size:CGFloat = 20) -> NSMutableAttributedString {
        let attributes = [NSAttributedStringKey.strokeWidth: -borderWidth,
                          NSAttributedStringKey.strokeColor: borderColour,
                          NSAttributedStringKey.font : UIFont.systemFont(ofSize: size),
                          NSAttributedStringKey.foregroundColor: textColour] as [NSAttributedStringKey : Any];
        
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        append(attributedText)
        return self
    }
    
    @discardableResult func setBorderToText(_ text: String, _ borderWidth:CGFloat, _ borderColour:UIColor, _ textColour:UIColor, _ font:UIFont) -> NSMutableAttributedString {
        let attributes = [NSAttributedStringKey.strokeWidth: -borderWidth,
                          NSAttributedStringKey.strokeColor: borderColour,
                          NSAttributedStringKey.font : font,
                          NSAttributedStringKey.foregroundColor: textColour] as [NSAttributedStringKey : Any];
        
        let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        append(attributedText)
        return self
    }
    
    /* let formattedString = NSMutableAttributedString()
     formattedString.setUnderLine(String Test)
     let lbl = UILabel()
     lbl.attributedText = formattedString
     */
    // MARK: - Set Underline to text
    /**
     Here is a neat way to add underline to text
     
     - Parameters:
        - text : Border text
     
     - Returns: attrbuted string with Underline text.
     
     */
    @discardableResult func setUnderLine(_ text: String) -> NSMutableAttributedString {
        append(NSAttributedString(string: text, attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]))
        return self
    }
    
    @discardableResult func setUnderLine(text: String, textColour:UIColor) -> NSMutableAttributedString {
        append(NSAttributedString(string: text, attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,  NSAttributedStringKey.foregroundColor: textColour]))
        return self
    }
    
}

/*
 
 let string = "Hello USA 🇺🇸 !!! Hello World !!!"
 
 if let range = string.range(of: "Hello World") {
 let nsRange = string.nsRange(from: range)
 (string as NSString).substring(with: nsRange) //  "Hello World"
 }
 
 
 let string = "Hello USA 🇺🇸 !!! Hello World !!!"
 
 if let nsRange = string.nsRange(of: "Hello World") {
 (string as NSString).substring(with: nsRange) //  "Hello World"
 }
 let nsRanges = string.nsRanges(of: "Hello")
 print(nsRanges)   // "[{0, 5}, {19, 5}]\n"
 
 
 */

extension StringProtocol where Index == String.Index {
    
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func nsRange<T: StringProtocol>(of string: T, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> NSRange? {
        guard let range = self.range(of: string, options: options, range: range ?? startIndex..<endIndex, locale: locale ?? .current) else { return nil }
        return NSRange(range, in: self)
    }
    func nsRanges<T: StringProtocol>(of string: T, options: String.CompareOptions = [], range: Range<Index>? = nil, locale: Locale? = nil) -> [NSRange] {
        var start = range?.lowerBound ?? startIndex
        let end = range?.upperBound ?? endIndex
        var ranges: [NSRange] = []
        while start < end, let range = self.range(of: string, options: options, range: start..<end, locale: locale ?? .current) {
            ranges.append(NSRange(range, in: self))
            start = range.upperBound
        }
        return ranges
    }
}

/*
 let string = "Many animals here: 🐶🦇🐱 !!!"
if let range = string.range(of: "🐶🦇🐱"){
    print((string as NSString).substring(with: NSRange(range))) //  "🐶🦇🐱"
}
 */

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}

