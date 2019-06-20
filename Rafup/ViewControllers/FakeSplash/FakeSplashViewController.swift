//
//  fakeSplashViewController.swift
//  Underwrite-it
//
//  Created by Ashish on 06/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class FakeSplashViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    
    
    // MARK: -  Variable Declaration.

    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserProfileModel.getUserLogin() != nil {
            self.apiCallForUserProfile()
        } else {
            self.setupInitailView()
        }
        
    }

    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        if UserProfileModel.getUserLogin() != nil {
            //===============================
            //  Move into App with login
            //===============================
            if let options = Constants.kAppDelegate.launchOptions, let notifications = options[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                DispatchQueue.main.async {
                    Constants.kAppDelegate.applicationLoggedInSuccessfully(notifications, animated: false)
                }
            } else {
                DispatchQueue.main.async {
                    Constants.kAppDelegate.applicationLoggedInSuccessfully(nil, animated: false)
                }
            }
        } else {
            //===============================
            //      Move to login page
            //===============================
            if let initialNavigation = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "NavigationID") as? UINavigationController {
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController = initialNavigation
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                }
            }
        }
    }
    
    // MARK: -  IBAction Methods.
    
    
    // MARK: -  Memory warning and handling Method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will
     often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: -  API Calling Methods.
extension FakeSplashViewController {
    func apiCallForUserProfile() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id" : user.id ?? 0
                ] as [String : Any]
                //  Global.showLoadingSpinner()
            ApiManager.apiCallForGetUserProfile(parameters: parameters) { (responseObject, error) in
                //  Global.dismissLoadingSpinner()
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [String:Any] {
                        user.updateUserAndSave(attributes: datas)
                        
                        DispatchQueue.main.async {
                            self.setupInitailView()
                        }
                    }
                }
            }
        }
    }
}


