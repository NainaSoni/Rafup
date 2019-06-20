//
//  UIApplication.swift
//  SlideMenuControllerSwift
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//
import UIKit
import SafariServices

public extension UIApplication {
    
    class var appDetails: String {
        get {
            if let dict = Bundle.main.infoDictionary {
                if let shortVersion = dict["CFBundleShortVersionString"] as? String,
                    let mainVersion = dict["CFBundleVersion"] as? String,
                    let appName = dict["CFBundleName"] as? String {
                    return "You're using \(appName) Version: \(mainVersion) (Build \(shortVersion))."
                }
            }
            return ""
        }
    }
    class var appName: String {
        get {
            let mainBundle = Bundle.main
            let displayName = mainBundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            let name = mainBundle.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
            return displayName ?? name ?? "Unknown"
        }
    }
    
    class var versionString: String {
        get {
            let mainBundle = Bundle.main
            let buildVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            let version = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            return buildVersionString ?? version ?? "Unknown Version"
        }
    }
    class var shortVersionString: String {
        get {
            let mainBundle = Bundle.main
            let buildVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            let version = mainBundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            return buildVersionString ?? version ?? "Unknown Version"
        }
    }
        
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
 
        
        /*
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // topController should now be your topmost view controller
        }
        */
        /*if let slide = viewController as? SSASideMenu {
            if let controller = slide.contentViewController as? UINavigationController {
                return controller.viewControllers.last
            }
        }*/
        
        /*if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }*/
        
        return viewController
    }
    
    class func isFirstLaunch(_ key: String) -> Bool {
        if !UserDefaults.standard.bool(forKey: key) {
            //NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)
            //NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        return false
        
        /*
        let defaults = UserDefaults.standard
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
         */
    }

    
    class func tryURL(urls: [String]) {

        for url in urls {
            if UIApplication.shared.canOpenURL(url.makeURL()!) {
                
                if #available(iOS 9.0, *) {
                    let safariVC = SFSafariViewController(url: url.makeURL()!)
                    self.topViewController()?.present(safariVC, animated: true, completion: nil)
                } else {
                    UIApplication.shared.openURL(url.makeURL()!)
                }

                /*if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url.makeURL()!, completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url.makeURL()!)
                }*/
                return
            }
        }
    }
    
    //MARK:- Setup Navigation bar appearance
    class func prepareBarAppearance(isLightContent: Bool) {
        if isLightContent {
            
            print(UIFont.printFonts())
            UIApplication.shared.statusBarStyle = .lightContent
            
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().barTintColor = UIColor.appNavigation
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedStringKey.font: UIFont(font: .avenirBook, size: 16) ?? UIFont.systemFont(ofSize: 16) ,
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
            let barButtonItem = UIBarButtonItem.appearance()
            let barButtonAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
                                       NSAttributedStringKey.foregroundColor: UIColor.white]
            barButtonItem.setTitleTextAttributes(barButtonAttributes, for: .normal)
        } else {
            UIApplication.shared.statusBarStyle = .lightContent
            UINavigationBar.appearance().tintColor = UIColor.white
            UINavigationBar.appearance().barTintColor = UIColor.appNavigation
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedStringKey.font: UIFont(font: .avenirBook, size: 16) ?? UIFont.systemFont(ofSize: 16) ,
                NSAttributedStringKey.foregroundColor : UIColor.white
            ]
            let barButtonItem = UIBarButtonItem.appearance()
            let barButtonAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18),
                                       NSAttributedStringKey.foregroundColor: UIColor.white]
            barButtonItem.setTitleTextAttributes(barButtonAttributes, for: .normal)
        }
    }
    
    /*Example for use:
     
     UIApplication.tryURL([
                "fb://profile/116374146706", // App
                "www.facebook.com/116374146706" // Website if app fails
     ])*/
}

public extension UIWindow {
    
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
