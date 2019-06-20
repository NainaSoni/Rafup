//
//  UIScreenExtension.swift
//  AirPool
//
//  Created by Ashish on 23/02/18.
//  Copyright © 2018 DS. All rights reserved.
//

//  UIScreen.main.screenType == .iPhone4_4S   [For check device type]
//  UIDevice.current.screenType.rawValue         [For get device name]

import UIKit

extension UIScreen {
    
    // MARK: - Device Size Checks
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436, 2048:
            return .iPhoneX
        default:
            return .unknown
        }
    }
    
    // MARK: - Get Device Sizes
    var screen_Width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    var screen_Height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    var screen_Max_Length: CGFloat {
        return max(screen_Width, screen_Height)
    }
    
    var screen_Min_Length: CGFloat {
        return min(screen_Width, screen_Height)
    }
}

