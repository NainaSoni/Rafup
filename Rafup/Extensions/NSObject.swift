//
//  NSObject.swift
//  WhyQ
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import UIKit

public extension NSObject  {
    
    /*
    var customDescription: String {
        let aClass : AnyClass? = type(of: self)
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<Ivar?> = class_copyIvarList(aClass, &propertiesCount)
        let className  = "\(NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? "")"
        
        var descriptionData = [String:Any]()
        for i in 0 ..< Int(propertiesCount) {
            if let key = String(cString: ivar_getName(propertiesInAClass[i]), encoding: String.Encoding.utf8) {
                var value: Any = "nil"
                if let propValue = self.value(forKey: key) {
                    value = propValue
                }
                let key = "\(key)"
                descriptionData[key] = value
            }
        }
        
        return "\n*** \(className) ***\n" + "\(descriptionData)"
    }
 */
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
