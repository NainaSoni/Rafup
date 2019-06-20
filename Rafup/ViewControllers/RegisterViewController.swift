//
//  RegisterViewController.swift
//  Rafup
//
//  Created by Ashish on 13/08/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit
import SafariServices

class RegisterViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var nameTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var emailTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var postCodeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var addressTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var phoneNumberTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var passwordTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var shoeSizeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var topSizeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var trouserTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var confirmPasswordTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var trouserLengthTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var mailingListBtn: UIButton!
    @IBOutlet weak var userImageVw: UIImageView!
    @IBOutlet weak var uploadImageVw: UIImageView!
    @IBOutlet weak var uploadIdBtn: UIButton!
    @IBOutlet weak var ageBtn: UIButton!
    @IBOutlet weak var MFSegment: UISegmentedControl!
    
    
    
    // MARK: -  Variable Declaration.
    var maleLengthArr = ["6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28","30", "32", "34", "36", "38", "40", "42"]
    var femaleLengthArr = ["6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28","30", "32", "34", "36", "38", "40", "42"]
    
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
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Register")
        self.navigationController?.removeBackButtonTitle()

        
        self.shoeSizeTxtFld.setRightViewImage(#imageLiteral(resourceName: "drop"))
        self.shoeSizeTxtFld.inputPicker = true
        self.shoeSizeTxtFld.pickerArray = ["UK 0.5","UK 1","UK 1.5","UK 2","UK 2.5","UK 3","UK 3.5","UK 4","UK 4.5","UK 5","UK 5.5", "UK 6", "UK 6.5", "UK 7", "UK 7.5", "UK 8", "UK 8.5", "UK 9", "UK 9.5", "UK 10", "UK 10.5", "UK 11", "UK 11.5","UK 12", "UK 12.5","UK 13", "UK 13.5","UK 14", "UK 14.5","UK 15","UK 15.5","UK 16","UK 16.5","UK 17","UK 17.5","UK 18","UK 18.5"]
        
        self.topSizeTxtFld.setRightViewImage(#imageLiteral(resourceName: "drop"))
        self.topSizeTxtFld.inputPicker = true
        self.topSizeTxtFld.pickerArray = ["XS", "S", "M", "L", "XL", "0X", "1X", "2X", "3X"]
        
        self.trouserTxtFld.setRightViewImage(#imageLiteral(resourceName: "drop"))
        self.trouserTxtFld.inputPicker = true
        self.trouserTxtFld.pickerArray = ["24","26","28", "30", "32", "34", "36", "38", "40", "42", "44", "46", "48", "50", "52", "54", "56", "58", "60"]
        
        self.trouserLengthTxtFld.setRightViewImage(#imageLiteral(resourceName: "drop"))
        self.trouserLengthTxtFld.inputPicker = true
        self.trouserLengthTxtFld.pickerArray = maleLengthArr
        
        //Set textfield copy paste action
        self.passwordTxtFld.isAllowedCopy = false
        self.passwordTxtFld.isAllowedPaste = false
        
        self.confirmPasswordTxtFld.isAllowedCopy = false
        self.confirmPasswordTxtFld.isAllowedPaste = false
        
        self.phoneNumberTxtFld.delegate = self
        
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.nameTxtFld.bottomLine             = true
            self.emailTxtFld.bottomLine            = true
            self.postCodeTxtFld.bottomLine         = true
            self.addressTxtFld.bottomLine          = true
            self.phoneNumberTxtFld.bottomLine      = true
            self.passwordTxtFld.bottomLine         = true
            self.confirmPasswordTxtFld.bottomLine  = true
            self.shoeSizeTxtFld.bottomLine         = true
            self.topSizeTxtFld.bottomLine          = true
            self.trouserTxtFld.bottomLine          = true
            self.trouserLengthTxtFld.bottomLine    = true
        }
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func MFSegmentBtnPress(_ sender: Any) {
        self.view.endEditing(true)
        switch MFSegment.selectedSegmentIndex {
        case 0:
            self.trouserLengthTxtFld.text = ""
            self.trouserLengthTxtFld.pickerArray = self.maleLengthArr
        case 1:
            self.trouserLengthTxtFld.text = ""
            self.trouserLengthTxtFld.pickerArray = self.femaleLengthArr
        default:
            break;
        }
    }
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        
        if ValidationHandel.validate(forSignup: self) {
            self.apiCallForRegisterUser()
        }
    }
    
    @IBAction func didTapJoinMailingListButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func didTap18PlusButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.uploadIdBtn.isHidden = false
            self.uploadImageVw.isHidden = false
        } else {
            self.uploadIdBtn.isHidden = true
            self.uploadImageVw.isHidden = true
        }
    }
    
    @IBAction func didTapUploadIDButton(_ sender: UIButton) {
        MediaUtilityClass.sharedInstanse().pickImage(message:  "Choose valid id image", completionHandler: { (img, imageURL, error) in
            if let image = img {
                self.uploadImageVw.image = image
            }
        })
    }
    
    @IBAction func didTapTermsAndConditionButton(_ sender: UIButton) {
        if let terms = URL.init(string: Urls.tersmsAndCondition) {
            let svc = SFSafariViewController(url: terms)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapUserImageChangeButton(_ sender: UIButton) {
        MediaUtilityClass.sharedInstanse().pickImage(message:  "Choose user image", completionHandler: { (img, imageURL, error) in
            if let image = img {
                self.userImageVw.image = image
            }
        })
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
// MARK: -  UITextFieldDelegate Methods.
extension RegisterViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField == self.phoneNumberTxtFld {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}

// MARK: -  API Calling Methods.
extension RegisterViewController {
    
    func apiCallForRegisterUser() {
        
        Global.showLoadingSpinner()
        
        var parameters = [ "Name"     : nameTxtFld.text ?? "",
                           "Email"    : emailTxtFld.text ?? "",
                           "Zipcode"  : postCodeTxtFld.text ?? "",
                           "Address"  : addressTxtFld.text ?? "",
                           "Mobile"   : phoneNumberTxtFld.text ?? "",
                           "DeviceToken" : Constants.kAppDelegate.deviceID,
                           "DeviceType"  : Constants.kDeviceType
            ] as [String : Any]
        
        parameters.merge(with: ["Password" : passwordTxtFld.text ?? "",
                                "IsJoinMaiing"  : mailingListBtn.isSelected,
                                "IsEighteenPlus": ageBtn.isSelected,
                                "ShoeSize"      : shoeSizeTxtFld.text ?? "",
                                "TrouserSize"   : trouserTxtFld.text ?? "",
                                "Length"        : trouserLengthTxtFld.text ?? "",
                                "Gender"        : MFSegment.selectedSegmentIndex == 0 ? "M" : "F",
                                "TopSize"       : topSizeTxtFld.text ?? ""])
        
        // Both image upload
        if ageBtn.isSelected && !(self.userImageVw.image?.areEqualImages(image: #imageLiteral(resourceName: "user_default")) ?? true) {
            parameters.merge(with: ["Images":[["Image":self.uploadImageVw.image!.base64String(), "Name":"ValidId"], ["Image": self.userImageVw.image!.base64String(), "Name":"Profile"]]])
        } else if ageBtn.isSelected && (self.userImageVw.image?.areEqualImages(image: #imageLiteral(resourceName: "user_default")) ?? true) {
            // Only id upload
            parameters.merge(with: ["Images":[["Image":self.uploadImageVw.image!.base64String(), "Name":"ValidId"]]])
        } else if !(self.userImageVw.image?.areEqualImages(image: #imageLiteral(resourceName: "user_default")) ?? true) {
            // Only User Image upload
            parameters.merge(with: ["Images":[["Image":self.userImageVw.image!.base64String(), "Name":"Profile"]]])
        }
        
        ApiManager.apiCallForSignUp(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if let responseObjects = responseObject {
                var messages = ConstantsMessages.kSucessfullyRegister
                if let message = responseObjects["ResponseMessage"] as? String {
                    messages = message
                }
                DispatchQueue.main.async {
                    self.presentAlertWith(message: messages, oktitle: "Ok", okaction: {
                    })
                }
            }
        }
        
    }
}
