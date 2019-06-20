//
//  ProfileViewController.swift
//  Rafup
//
//  Created by Ashish on 25/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backgroundVw: GradientView!
    @IBOutlet weak var nameTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var emailTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var postCodeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var addressTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var phoneNumberTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var shoeSizeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var topSizeTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var trouserTxtFld: CustomTextFieldAnimated!
    
    @IBOutlet weak var trouserLenghtTxtFld: CustomTextFieldAnimated!
    @IBOutlet weak var mailingListBtn: UIButton!
    @IBOutlet weak var userImageVw: UIImageView!
    @IBOutlet weak var uploadImageVw: UIImageView!
    @IBOutlet weak var uploadIdBtn: UIButton!
    @IBOutlet weak var ageBtn: UIButton!
    @IBOutlet weak var MFSegment: UISegmentedControl!
    
    // MARK: -  Variable Declaration.
    var isChangeUserImage = false
    var isChangeValidId   = false
    var maleLengthArr = ["6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28","30", "32", "34", "36", "38", "40", "42"]
    var femaleLengthArr = ["6", "8", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28","30", "32", "34", "36", "38", "40", "42"]
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Profile")
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
        
        self.trouserLenghtTxtFld.setRightViewImage(#imageLiteral(resourceName: "drop"))
        self.trouserLenghtTxtFld.inputPicker = true
        self.trouserLenghtTxtFld.pickerArray = maleLengthArr
        
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.nameTxtFld.bottomLine             = true
            self.emailTxtFld.bottomLine            = true
            self.postCodeTxtFld.bottomLine         = true
            self.addressTxtFld.bottomLine          = true
            self.phoneNumberTxtFld.bottomLine      = true
            self.shoeSizeTxtFld.bottomLine         = true
            self.topSizeTxtFld.bottomLine          = true
            self.trouserTxtFld.bottomLine          = true
            self.trouserLenghtTxtFld.bottomLine    = true
            
            self.backgroundVw.gradientLayer.colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor]
            self.backgroundVw.gradientLayer.gradient = GradientPoint.rightLeft.draw()
            
        }
        
        self.setUpUI()
        
        self.apiCallForUserProfile()
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func MFSegmentBtnPress(_ sender: Any) {
        self.view.endEditing(true)
        switch MFSegment.selectedSegmentIndex {
        case 0:
            self.trouserLenghtTxtFld.text = ""
            self.trouserLenghtTxtFld.pickerArray = self.maleLengthArr
        case 1:
            self.trouserLenghtTxtFld.text = ""
            self.trouserLenghtTxtFld.pickerArray = self.femaleLengthArr
        default:
            break;
        }
    }
    
    // MARK: -  Setup Methods.
    func setUpUI() {
        //  Set User Header
        if let user = UserProfileModel.getUserLogin() {
            self.nameLbl.text  = user.username ?? ""
            self.userImageVw.setImageWithURL(url: user.userImage ?? "", placeholder: AssetsImages.kDefaultUser, contentMode: self.userImageVw.contentMode)
            self.uploadImageVw.setImageWithURL(url: user.validId ?? "", placeholder:nil, contentMode: self.uploadImageVw.contentMode)
            self.nameTxtFld.text = user.username ?? ""
            self.emailTxtFld.text = user.email ?? ""
            self.addressTxtFld.text = user.address ?? ""
            self.postCodeTxtFld.text = user.zipCode ?? ""
            self.phoneNumberTxtFld.text = user.mobileNumber ?? ""
            self.shoeSizeTxtFld.text = user.shoeSize ?? ""
            self.topSizeTxtFld.text = user.tShirtSize ?? ""
            self.trouserTxtFld.text = user.touserSize ?? ""
            self.trouserLenghtTxtFld.text = user.length ?? ""
            self.ageBtn.isSelected = user.isEighteenPlus ?? false
            self.mailingListBtn.isSelected = user.isJoiningMail ?? false
            if self.ageBtn.isSelected {
                self.uploadIdBtn.isHidden = false
                self.uploadImageVw.isHidden = false
            } else {
                self.uploadIdBtn.isHidden = true
                self.uploadImageVw.isHidden = true
            }
            
            if user.isEighteenVerified ?? false {
                self.ageBtn.isUserInteractionEnabled = false
            }
            user.gender == "M" ? (MFSegment.selectedSegmentIndex = 0) : (MFSegment.selectedSegmentIndex = 1)
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapUpdateButton(_ sender: UIButton) {
        
        if ValidationHandel.validate(foProfile: self) {
            self.apiCallForUpdateUserProfile()
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
                self.isChangeValidId = true
            }
        })
    }
    
    @IBAction func didTapUserImageChangeButton(_ sender: UIButton) {
        MediaUtilityClass.sharedInstanse().pickImage(message:  "Choose user image", completionHandler: { (img, imageURL, error) in
            if let image = img {
                self.userImageVw.image = image
                self.isChangeUserImage = true
            }
        })
    }

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
extension ProfileViewController {
    
    func apiCallForUpdateUserProfile() {
        
        Global.showLoadingSpinner()
        let user = UserProfileModel.getUserLogin()
        var parameters = [ "Name"     : nameTxtFld.text ?? "",
                           "Email"    : emailTxtFld.text ?? "",
                           "Zipcode"  : postCodeTxtFld.text ?? "",
                           "Address"  : addressTxtFld.text ?? "",
                           "Mobile"   : phoneNumberTxtFld.text ?? "",
                           "UserId"   : user?.id ?? 0,
            ] as [String : Any]
        
        parameters.merge(with: ["IsJoinMaiing"  : mailingListBtn.isSelected,
                                "IsEighteenPlus": ageBtn.isSelected,
                                "ShoeSize"      : shoeSizeTxtFld.text ?? "",
                                "TrouserSize"   : trouserTxtFld.text ?? "",
                                "TopSize"       : topSizeTxtFld.text ?? "",
                                "Length"        : trouserLenghtTxtFld.text ?? "",
                                "Gender"        : MFSegment.selectedSegmentIndex == 0 ? "M" : "F",])
        
        // Both image upload
        if isChangeValidId && isChangeUserImage {
            parameters.merge(with: ["Images":[["Image":self.uploadImageVw.image!.base64String(), "Name":"ValidId"], ["Image": self.userImageVw.image!.base64String(), "Name":"Profile"]]])
        } else if ageBtn.isSelected && self.isChangeValidId {
            // Only id upload
            parameters.merge(with: ["Images":[["Image":self.uploadImageVw.image!.base64String(), "Name":"ValidId"]]])
        } else if isChangeUserImage {
            // Only User Image upload
            parameters.merge(with: ["Images":[["Image":self.userImageVw.image!.base64String(), "Name":"Profile"]]])
        }
        
        ApiManager.apiCallForUpdateProfile(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if let responseObjects = responseObject {
                var messages = ConstantsMessages.kSucessfullyRegister
                if let message = responseObjects["ResponseMessage"] as? String {
                    messages = message
                }
                
                DispatchQueue.main.async {
                    self.presentAlertWith(message: messages, oktitle: "Ok", okaction: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                
                //change uservalue in side menu
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userData"), object: nil)
            }
        }
    }
    
    func apiCallForUserProfile() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id" : user.id ?? 0
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetUserProfile(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [String:Any] {
                        user.updateUserAndSave(attributes: datas)
                        DispatchQueue.main.async {
                            self.setUpUI()
                        }
                    }
                }
            }
        }
    }
}
