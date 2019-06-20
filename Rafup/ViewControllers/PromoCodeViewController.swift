//
//  PromoCodeViewController.swift
//  Rafup
//
//  Created by Ashish on 25/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var emailTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var pointsTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var lblPoints: UILabel!
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
        self.setNavigation(title: "Share Points")
        self.navigationController?.removeBackButtonTitle()
        
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.emailTxtFld.bottomLine   = true
            self.pointsTxtFld.bottomLine  = true
            
              //Set User Header
              if let user = UserProfileModel.getUserLogin() {
                    self.lblPoints.text = "\(user.points ?? 0)"
              }
            self.emailTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            self.pointsTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
            
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        
        if ValidationHandel.validate(forPromoCode: self) {
            if sender.isSelected == true {
                //===============================
                //      Share On Social Media
                //===============================
                if let user = UserProfileModel.getUserLogin() {
                    DispatchQueue.main.async {
                        self.socialShare(with: "\(user.username ?? "") share \(self.pointsTxtFld.text ?? "") points with \(self.emailTxtFld.text ?? "")", image: nil , url: nil)
                    }
                }
            } else {
                //===============================
                //         Share Points
                //===============================
                if self.pointsTxtFld.text == "0"{
                    self.presentAlertWith(message: "Please enter valid points to share", oktitle: "Ok", okaction: {
                    })
                }else{
                    self.apiCallForSharePoints()
                }
                
            }
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
extension PromoCodeViewController {
    
    func apiCallForSharePoints() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "ReciverEmail" : emailTxtFld.text ?? "",
                               "SenderId"     : user.id ?? 0,
                               "points"       : pointsTxtFld.text ?? ""
                            ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForSharePoints(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if let responseObjects = responseObject {
                    var messages = ConstantsMessages.kSharePoints
                    if let message = responseObjects["ResponseMessage"] as? String {
                        messages = message
                    }
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: messages, oktitle: "Ok", okaction: {
                            self.submitBtn.isSelected = true
                        })
                    }
                }
            }
        }
    }
}
