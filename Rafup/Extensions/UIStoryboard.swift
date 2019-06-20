//
//  UIStoryboardExtension.swift
//  AirPool
//
//  Created by Ashish on 23/02/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

// MARK: - Methods
public enum storyboard:String {
    case main       = "Main"
    case history    = "History"
}

public extension UIStoryboard {
    
    /// SwifterSwift: Get main storyboard for application
    public static var mainStoryboard: UIStoryboard? {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    public static var historyStoryboard: UIStoryboard? {
        return UIStoryboard(name: "History", bundle: nil)
    }
    
    /// Instantiate a UIViewController using its class name
    ///
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to specified class name
    public func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: name.className) as? T
    }
    
    public static func loadStoryboard(type:storyboard) -> UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: type.rawValue) as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }
    
}
