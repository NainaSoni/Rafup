//
//  AppDelegate+LoginUser.swift
//  Prototype
//
//  Created by Ashish Soni on 05/03/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit
import LGSideMenuController

typealias VoidHandler = ()->Void

extension AppDelegate {
    
    //MARK:- setup Logged In Successfully
    func applicationLoggedInSuccessfully(_ info: [AnyHashable: Any]!, animated: Bool = true) {
        
        if (UserProfileModel.getUserLogin() != nil) {
            
            let homeViewController = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "sideMenuRootNavigation") as! UINavigationController
            
            let leftSideMenuViewController = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: SideMenuViewController.className) as! SideMenuViewController
            
            let sideMenuController = LGSideMenuController(rootViewController: homeViewController,
                                                          leftViewController: leftSideMenuViewController,
                                                          rightViewController: nil)
            
            
            self.setupSideMenu(sidemenu: sideMenuController)
            
            self.sideMenu = sideMenuController
            
            let duration = animated ? 0.5 : 0.0
            
            var currentLodedVC = self.window?.rootViewController
            
            UIView.transition(with: self.window!, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                self.window?.rootViewController = self.sideMenu
                self.window?.backgroundColor = UIColor.white
                self.window?.makeKeyAndVisible()
                
            }) { (finished) -> Void in
                if currentLodedVC != nil {
                    currentLodedVC?.view.removeFromSuperview()
                    currentLodedVC = nil
                }
                if let info = info {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.applicationDidReceiveRemoteNotificationInBackground(.inactive, notificationInfo: info)
                    })
                }
            }
        }
    }
    
    //MARK:- Logout User
    func logout() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id" : user.id ?? 0
            ]
            Global.showLoadingSpinner()
            ApiManager.apiCallForLogOut(parameters: parameters, completionHandler: { (jsonObject, error) in
                Global.dismissLoadingSpinner()
            })
        } else { self.clearAppOnLogout() }
    }
    
    //MARK:- clear All App Data
    func clearAppOnLogout(showAlert alert: Bool? = false) { // fileprivate
        Global.dismissLoadingSpinner()
        Global.clearAllAppUserDefaults()
        
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let vc =  Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "NavigationID")
            self.window?.rootViewController = vc
            self.window?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.window?.makeKeyAndVisible()
        }, completion: nil)
    }
    
    //MARK:- setup side menu properties.
    func setupSideMenu(sidemenu: LGSideMenuController) {
        sidemenu.leftViewWidth = 250.0;
        sidemenu.leftViewPresentationStyle = .slideBelow;
    }

    
    /*func logoutApplication(_ info: [AnyHashable: Any]!, animated: Bool = true) {
     self.user = nil
     Global.clearAllAppUserDefaults()
     let loginVavigation = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
     let duration = animated ? 0.5 : 0.0
     var currentLodedVC = self.window?.rootViewController
     UIView.transition(with: self.window!, duration: duration, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
     self.window?.rootViewController = loginVavigation
     self.window?.backgroundColor = UIColor.white
     self.window?.makeKeyAndVisible()
     }) { (finished) -> Void in
     if currentLodedVC != nil {currentLodedVC?.view.removeFromSuperview()
     currentLodedVC = nil}
     if (info) != nil { }}}
    
    fileprivate func loadFakeScreen( handler:@escaping VoidHandler) {
        let vc = ViewController.storyboardInstance()
        //vc.finishHandler = handler
        UIView.transition(with: self.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { () -> Void in
            self.window?.rootViewController = vc
            self.window?.backgroundColor = UIColor.white
            self.window?.makeKeyAndVisible()
        }) { (finished) -> Void in }
    }
    */
}
