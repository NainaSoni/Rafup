//
//  ChangePasswordViewController.swift
//  Rafup
//
//  Created by Ashish on 09/10/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var oldPasswordTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var newPasswordTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var confirmPasswordTxtFld: CustomTextFieldAnimated!
    
    // MARK: -  Variable Declaration.
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Change Password")
        self.navigationController?.removeBackButtonTitle()
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.oldPasswordTxtFld.bottomLine  = true
            self.newPasswordTxtFld.bottomLine  = true
            self.confirmPasswordTxtFld.bottomLine  = true
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
            self.oldPasswordTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            self.newPasswordTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            self.confirmPasswordTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSumitButton(_ sender: UIButton) {
        if ValidationHandel.validate(foChangePassword: self) {
            self.apiCallForChangePassword()
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
extension ChangePasswordViewController {
    
    func apiCallForChangePassword() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id"          : user.id ?? 0,
                               "newPassword" : newPasswordTxtFld.text ?? "",
                               "oldPassword" : oldPasswordTxtFld.text ?? ""
                            ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForChangePassword(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if let responseObjects = responseObject {
                    var messages = ConstantsMessages.kChangePassword
                    if let message = responseObjects["ResponseMessage"] as? String {
                        messages = message
                    }
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: messages, oktitle: "Ok", okaction: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
}
