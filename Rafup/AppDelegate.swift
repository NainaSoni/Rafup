//
//  AppDelegate.swift
//  Rafup
//
//  Created by Ashish on 03/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import LGSideMenuController
import Braintree
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    var deviceID = ""
    var sideMenu: LGSideMenuController?
    var launchOptions:[UIApplicationLaunchOptionsKey: Any]?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        BTAppSwitch.setReturnURLScheme("com.rafup.poc.payments")
        self.launchOptions = launchOptions
        self.registerForPushNotifications(application)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    
        if url.scheme?.localizedCaseInsensitiveCompare("com.your-company.Your-App.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String)
        }
        return false
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
