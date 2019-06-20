//
//  ForgotPasswordVC.swift
//  Rafup
//
//  Created by Ashish on 04/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var emailTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var submitBtn: UIButton!
    
    // MARK: -  Variable Declaration.
    
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         setupInitailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Show navigatioin bar.
        self.showNavigationBar()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Forgot password")
        self.navigationController?.removeBackButtonTitle()
            
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.emailTxtFld.bottomLine             = true
        }
        
    }

    // MARK: -  IBAction Methods.
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        
        if ValidationHandel.validate(forForgotPassword: self) {
             apiCallForForgotPassword()
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
extension ForgotPasswordVC {
    
    func apiCallForForgotPassword() {
        let parameters = [ "EmailId" : emailTxtFld.text ?? "",
                           "Status"  : "Forgot"
            ] as [String : Any]
        Global.showLoadingSpinner()
        ApiManager.apiCallForForgotPassword(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if let responseObjects = responseObject {
                var messages = ConstantsMessages.kForgotPassword
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
