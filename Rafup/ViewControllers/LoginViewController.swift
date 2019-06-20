//
//  LoginViewController.swift
//  Rafup
//
//  Created by Ashish on 13/08/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var emailTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var passwordTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var rememberMeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK: -  Variable Declaration.
    
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupInitailView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Show navigatioin bar.
        self.showNavigationBar()
        self.setTransparentNavigationBar()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        if(AppManager.isRemember()){
            rememberMeBtn.isSelected = true
        }
        
        //Set textfield copy paste action
        self.passwordTxtFld.isAllowedCopy = false
        self.passwordTxtFld.isAllowedPaste = false
        
        
        //Set Gradient to button
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.emailTxtFld.bottomLine = true
            self.passwordTxtFld.bottomLine = true
    
            self.setTopNavigation(for: [.back])
        }
        
        //Set Remember me email and password
        emailTxtFld.text    = AppManager.getEmail()
        passwordTxtFld.text = AppManager.getPassword()
        
        //For debug mode email, password prefill.
        if UIDevice.isDebugMode {
            if emailTxtFld.text == "" {
                emailTxtFld.text = "tester@mailinator.com"
                passwordTxtFld.text = "1234"
            }
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapRememberButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        //Check textfield validation
        if ValidationHandel.validate(forLogin: self) {
            self.apiCallForLoginUser()
        }
    }
    
    // MARK: -  Memory warning and handling Method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

// MARK: -  API Calling Methods.
extension LoginViewController {
    
    func apiCallForLoginUser() {
        let parameters = [ "Email" : emailTxtFld.text ?? "",
                           "Password" : passwordTxtFld.text ?? "",
                           "DeviceToken" : Constants.kAppDelegate.deviceID,
                           "DeviceType"  : Constants.kDeviceType
                        ]
        Global.showLoadingSpinner()
        ApiManager.apiCallForLogin(parameters: parameters, isRemember: rememberMeBtn.isSelected) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            
            //Save remember me object
            DispatchQueue.main.async {
                AppManager.isRememberobject(email: self.emailTxtFld.text ?? "" , passwordStr: self.passwordTxtFld.text ?? "", isRemeber: self.rememberMeBtn.isSelected)
            }
        }
    }
}
