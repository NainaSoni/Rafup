//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import UIKit

extension UIColor {
    
    /*************************************************************/
     //MARK:-   UIColor  : App Color Codes
     /*************************************************************/
    
    open class var appRedLayer1: UIColor {
        get {
            return #colorLiteral(red: 0.8352941176, green: 0.5490196078, blue: 0.3450980392, alpha: 1)
        }
    }
    
   /* open class var appRedLayer2: UIColor {
        get {
            return #colorLiteral(red: 0.6941176471, green: 0.07058823529, blue: 0.09019607843, alpha: 1)
        }
    } */
    
    open class var appCount: UIColor {
        get {
            return UIColor(hex: "2C7B9A")
        }
    }
    
    open class var appRedLayer2: UIColor {
        get {
            return UIColor(hex: "00D8C5")
        }
    }
    open class var appGreenLayer2: UIColor {
        get {
            return UIColor(hex: "28976A")
        }
    }
    
    public class func AppColor() -> UIColor {
        return UIColor(hex: "00D8C5")
    }
    public class func AppColorDarkGray() -> UIColor {
        return UIColor(hex: "555555")
    }
    
    public class func AppLightGrayColor() -> UIColor {
        return UIColor(hex: "AAAAAA")
    }
    public class func AppMoreLightGrayColor() -> UIColor {
        return UIColor(hex: "e0e0e0")
    }
    
    public class func AppMoreDarkGrayColor() -> UIColor {
        return UIColor(hex: "686868")
    }

    
    open class var appFacebook: UIColor {
        get {
            return UIColor(hex: "35548B")
        }
    }
    open class var appLightGray: UIColor {
        get {
            return UIColor(hex: "F1F0F1")
        }
    }
    open class var appGray: UIColor {
        get {
            return UIColor(hex: "D6D6D6")
        }
    }
    open class var appNavigation: UIColor {//# E43740
        get {
            return UIColor(hex: "00D8C5")
        }
    }
    open class var appRed: UIColor {
        get {
            return UIColor(hex: "00D8C5") 
        }
    }
    open class var appYellow: UIColor {
        get {
            return UIColor(hex: "FFB715")
        }
    }
    open class var appBlack: UIColor {
        get {
            return UIColor(hex: "003540")
        }
    }
    
    open class var appDarkBlue: UIColor {
        get {
            return UIColor(hex: "003441")
        }
    }
    open class var appDarkBlueDisable: UIColor {
        get {
            return UIColor(hex: "aeaeae")
        }
    }
    
    open class var AppIncomingChatColor: UIColor {
        get {
            return UIColor(hex: "E8E8E8")
        }
    }
    
    open class var AppOutgoingChatColor: UIColor {
        get {
            return  #colorLiteral(red: 0.9960784314, green: 0.8470588235, blue: 0.8549019608, alpha: 1)
        }
    }

/*
    Color info:
    Sky blue bg color - #c6f2f5
    Button bg color - #ce667a
    heading blue text color - #239fc4
    Search bar text color - #8c8c8c
    light bg color of km - #afd3d6
    first pink color bg -#f19bab
    second pink color bg -#ed8a9d
    third pink color bg - #dd778a
    fourth pink color bg -#ce667a
    */
    
    //195 150 91,  19 19 19, 135 93 72
    /*************************************************************/
     //MARK:-   Hex UIColor extensions
     /*************************************************************/
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    class func hexStr(_ hexStr: String) -> UIColor {
        return UIColor.hexStr(hexStr, alpha: 1)
    }
    
    convenience init(_ hex: UInt) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
    /*************************************************************/
     //MARK:-   Hex UIColor extensions
     /*************************************************************/
    open class func random() -> UIColor {
        let red = CGFloat(arc4random() % 256) / 256.0
        let green = CGFloat(arc4random() % 256) / 256.0
        let blue = CGFloat(arc4random() % 256) / 256.0
        let alpha = CGFloat(arc4random() % 256) / 256.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor.white
    }
    
    class func hexStr(_ str: String, alpha: CGFloat) -> UIColor {
        let hexStr = str.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: r, green: g, blue: b , alpha: alpha)
        } else {
            print("Invalid hex string")
            return .white
        }
    }
    
    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
