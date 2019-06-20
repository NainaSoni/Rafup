//
//  ContactUsViewController.swift
//  Rafup
//
//  Created by Ashish on 25/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var messageTxtVw: CustomTextView!
    
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
        self.setNavigation(title: "Contact Us")
        self.navigationController?.removeBackButtonTitle()
        
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.messageTxtVw.placeholder  = "Message"
            self.messageTxtVw.setInnerShadow(onSide: .all)
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
            
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSendButton(_ sender: UIButton) {
        
        if ValidationHandel.validate(forMessage: self) {
             self.apiCallForMessage()
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
extension ContactUsViewController {
    
    func apiCallForMessage() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "EmailBody" : messageTxtVw.text ?? "",
                               "Email" :  user.email ?? "",
                               "Name" : user.username ?? "",
                               "Subject" : "ContactUs"
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForContactUs(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if let responseObjects = responseObject {
                    var messages = ConstantsMessages.kMessage
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
