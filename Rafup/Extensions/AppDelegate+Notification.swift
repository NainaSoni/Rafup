//
//  AppDelegate+Notification.swift
//  Prototype
//
//  Created by Ashish Soni on 05/03/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit
import AudioToolbox
import UserNotifications
import LGSideMenuController
import Firebase

import FirebaseInstanceID
import FirebaseMessaging
// MARK: - Notification Objects and Keys.
extension Notification.Name {
    /// Used as a namespace for all `Notification` user info dictionary keys.
    static let resultNotification = Notification.Name(NotificationKeys.kResultRaffle)
}

public struct NotificationKeys {
    
    static let kResultRaffle = "resultRaffle"
}


enum NotificationType: String {
    case unknown                = ""
    case result                 = "quizResult"
    case promoCode              = "promoCode"
    case sharePoint             = "sharePoint"
    case newProduct             = "newProduct"
    //"newProduct"
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString: String = deviceToken.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
        
        //deviceID = deviceToken.hexString()
        print("Got token data! (deviceToken):\n\(deviceTokenString)")
        //deviceID = deviceTokenString
        
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error while fatching token data! \(error.localizedDescription)")
        deviceID = ""
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        applicationDidReceiveRemoteNotificationInBackground(application.applicationState, notificationInfo:userInfo)
    }
    
    //MARK:- setup application Did Receive Remote Notification In Background
    func applicationDidReceiveRemoteNotificationInBackground(_ appState: UIApplicationState, notificationInfo: [AnyHashable: Any]) {
        
        print(notificationInfo)
        NSLog("%@",notificationInfo)
        UIApplication.shared.applicationIconBadgeNumber = 0
        //Parsing userinfo:
        if let info = notificationInfo["aps"] as? [String: Any],
        let apns = info["alert"] as? [String:Any],
            let _ = UserProfileModel.getUserLogin(), let notificationType = notificationInfo["type"] as? String {
            
            guard let notification = NotificationType(rawValue: notificationType) else { return }
            
            let message = apns["body"] as? String ?? ""
            let title   = apns["title"] as? String ?? Constants.kAppDisplayName
            
            
            
            print(message)
            
            if appState == .inactive || appState == .background {
                
                //==================================
                //         Background State
                //==================================
                
                switch notification {
                case .result:
                    // isMessage = true
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                    
                case .unknown: break
                case .promoCode:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                        })
                    }
                case .sharePoint:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                case .newProduct:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                }
            } else {
                
                //==================================
                //         Forground State
                //==================================
                
                switch notification {
                    
                case .result:
                    
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                    
                case .unknown:
                    playSoundForNotification()
                    
               // default: break;
                case .promoCode:
                    
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                        })
                    }
                case .sharePoint:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                case .newProduct:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: notificationInfo)
                        })
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void)
    {
        //=====================================
        //          App in background
        //=====================================
        //APP BACKGROUND And
        //This is for the user tapping on the notification
        completionHandler()
        //print("###### Notification Info: \(response.notification.request.content.userInfo)")
        NSLog("%@",response.notification.request.content.userInfo)
        if let objDictionary = response.notification.request.content.userInfo as? [String:AnyObject] {
            if let info = objDictionary["aps"] as? [String: Any],
                let apns = info["alert"] as? [String:Any],
                let _ = UserProfileModel.getUserLogin(), let notificationType = objDictionary["type"] as? String {
                
                guard let notification = NotificationType(rawValue: notificationType) else { return }
                
                let message = apns["body"] as? String ?? ""
                let title   = apns["title"] as? String ?? Constants.kAppDisplayName
                
                switch notification {
                case .result:
                    // isMessage = true
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                case .unknown: break
                case .promoCode:
                    //self.playSoundForNotification()
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                case .sharePoint:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                case .newProduct:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter( _ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping ( _ options:   UNNotificationPresentationOptions) -> Void) {
        //=====================================
        //          App in fourground
        //=====================================
        //APP OPEN
        
        // Remote code when notificaytion type handle
        //completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
        // Remote code when notificaytion type handle
        
        print("###### Notification Info: \(notification.request.content.userInfo)")
        NSLog("%@",notification.request.content.userInfo)
        if let objDictionary = notification.request.content.userInfo as? [String:AnyObject] {
            if let info = objDictionary["aps"] as? [String: Any],
                let apns = info["alert"] as? [String:Any],
                let _ = UserProfileModel.getUserLogin(), let notificationType = objDictionary["type"] as? String {
                
                guard let notification = NotificationType(rawValue: notificationType) else { return }
                
                let message = apns["body"] as? String ?? ""
                let title   = apns["title"] as? String ?? Constants.kAppDisplayName
                
                switch notification {
                case .result:
                    // isMessage = true
                    //playSoundForNotification()
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    } // Display notification as regular alert and play sound
                    
                case .unknown:
                    //playSoundForNotification()
                    completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
//                default: break;
                case .promoCode:
                    self.playSoundForNotification()
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                case .sharePoint:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                case .newProduct:
                    DispatchQueue.main.async {
                        Global.showAlert(title:title, withMessage: message, handler: { (action) in
                            self.notificationAction(type: notification, info: objDictionary)
                        })
                    }
                }
            }
        }
    }
    
    // MARK : - Notification Deep Linking
    func notificationAction( type:NotificationType, info:[AnyHashable:Any]) {
    
        switch type {
        case .result:
            // go to historyVC
            self.jumbToViewControllerFromNotifiation(info: info, rootID: "historyNav")
        case .unknown: break;
        case .promoCode: break;
        case .sharePoint:
            // go to settingVC
            self.jumbToViewControllerFromNotifiation(info: info, rootID: "settingsNav")
        case .newProduct:
            // go to product detail
            self.jumbToViewControllerFromNotifiation(info: info, rootID: "sideMenuRootNavigation")
        }
        
        
        
    }
    
    //MARK:- Play Sound For Notification
    func playSoundForNotification() {
        AudioServicesPlayAlertSound(1007)
    }
    
    //MARK:- Push ViewController from Home.
    func pushFromHome(viewController:UIViewController) {
        let leftSideMenuViewController = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: SideMenuViewController.className) as! SideMenuViewController
        
        let sideMenuController = LGSideMenuController(rootViewController: viewController,
                                                      leftViewController: leftSideMenuViewController,
                                                      rightViewController: nil)
        
        
        self.setupSideMenu(sidemenu: sideMenuController)
        
        self.sideMenu = sideMenuController
        
        var currentLodedVC = self.window?.rootViewController
        
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            self.window?.rootViewController = viewController
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
            
        }) { (finished) -> Void in
            if currentLodedVC != nil {
                currentLodedVC?.view.removeFromSuperview()
                currentLodedVC = nil
            }
        }
    }
    
    //MARK:- Setup Push Notification Setting
    func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
    }
    
    @discardableResult func getLoginViewCntroller() -> UINavigationController? {
        if let initialNavigation = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "NavigationID") as? UINavigationController {
            UIApplication.shared.keyWindow?.rootViewController = initialNavigation
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
            return initialNavigation
        }
        return nil
    }
    
    
    
    
    func jumbToViewControllerFromNotifiation(info : [AnyHashable:Any] , rootID : String){
        let rootNavigation : UINavigationController
        if (rootID == "sideMenuRootNavigation"){
            rootNavigation = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: rootID) as! UINavigationController
        }else{
             rootNavigation = Storyboard.kHistoryStoryboard.instantiateViewController(withIdentifier: rootID) as! UINavigationController
        }
        
        
        
        let leftSideMenuViewController = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: SideMenuViewController.className) as! SideMenuViewController
        
        let sideMenuController = LGSideMenuController(rootViewController: rootNavigation,
                                                      leftViewController: leftSideMenuViewController,
                                                      rightViewController: nil)
        
        
        self.setupSideMenu(sidemenu: sideMenuController)
        
        self.sideMenu = sideMenuController
        
        let duration =  0.5
        
        var currentLodedVC = self.window?.rootViewController
        
        UIView.transition(with: self.window!, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            self.window?.rootViewController = self.sideMenu
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
            
            if (rootID == "historyNav"){
                
                if let productDetailVC = Storyboard.kHistoryStoryboard.instantiateViewController(withIdentifier: HistoryDetailViewController.className) as? HistoryDetailViewController {
                    
                    if let str = info["TicketId"] as? String, let i = Int(str) {
                        productDetailVC.ticketID = i
                    }
                    if let b = info["ResultStatus"] as? String  {
                        productDetailVC.productStatus = b
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        rootNavigation.viewControllers.first?.navigationController?.pushViewController(productDetailVC)
                    })
                }
            }else if (rootID == "sideMenuRootNavigation"){
                if let productDetailVC = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: ProductDetailViewController.className) as? ProductDetailViewController {
                    
                    if let str = info["ProductId"] as? String, let i = Int(str) {
                        productDetailVC.productID = i
                        productDetailVC.isFromNotification = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        rootNavigation.viewControllers.first?.navigationController?.pushViewController(productDetailVC)
                    })
                }
            }
            
        }) { (finished) -> Void in
            if currentLodedVC != nil {
                currentLodedVC?.view.removeFromSuperview()
                currentLodedVC = nil
            }
        }
    }
    
    
    
    
    
}
extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("Firebase registration token: \(fcmToken)")
        deviceID = fcmToken
        Constants.kUserDefaults.set(fcmToken, forKey: "iappToken")
        
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        NSLog("Received data message: \(remoteMessage.appData)")
    }
}
