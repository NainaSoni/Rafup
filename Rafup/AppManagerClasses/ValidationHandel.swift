//
//  ValidationClass.swift
//  Underwrite-it
//
//  Created by Ashish on 06/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import CoreLocation

public class ValidationHandel: NSObject {
    
    
    //MARK:-   Validate : Login Form
    
    class func validate(forLogin object: LoginViewController) -> Bool {
        
        if ValidationRules.isBlank(object.emailTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmail.description, sender: object)
            return false
        } else if ValidationRules.isValid(email: object.emailTxtFld.text!) {
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        }
        else if ValidationRules.isBlank(object.passwordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password can't be blank.").description, sender: object)
            return false
        }
        /*else if (object.passwordTxtFld.text ?? "").count < 4 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        }
        else if (object.passwordTxtFld.text ?? "").count > 15 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        }*/
        else {
            object.view.endEditing(true)
            return true
        }
    }
    
    
    //MARK:-   Validate : SignUp Form
    
    class func validate(forSignup object: RegisterViewController) -> Bool {
        
        if ValidationRules.isBlank(object.nameTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyName.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.emailTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmail.description, sender: object)
            return false
        } else if ValidationRules.isValid(email: object.emailTxtFld.text!) {
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.postCodeTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Post code can't be blank.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.addressTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Address can't be blank.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.phoneNumberTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Phone number is required and can't be empty").description, sender: object)
            return false
        } else if object.phoneNumberTxtFld.text!.count < 10 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Phone number should be 10 to 16 digit long.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.passwordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password can't be blank.").description, sender: object)
            return false
        } else if (object.passwordTxtFld.text ?? "").count < 4 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        } else if (object.passwordTxtFld.text ?? "").count > 15 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.confirmPasswordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Confirm password can't be blank.").description, sender: object)
            return false
        } else if object.passwordTxtFld.text != object.confirmPasswordTxtFld.text {
            Global.showAlert(withMessage: ValidationError.OfType.emptyConfirmPassword.description, sender: object)
            return false
        } else if object.ageBtn.isSelected && (object.uploadImageVw.image == nil) {
            Global.showAlert(withMessage:ValidationError.OfType.errorWithMessage(message: "Please choose valid id for age confirmation.").description, sender: object)
            return false
        } else if !ValidationRules.isBlank(object.trouserTxtFld){
            if ValidationRules.isBlank(object.trouserLengthTxtFld){
                Global.showAlert(withMessage:ValidationError.OfType.errorWithMessage(message: "Please choose trouser length.").description, sender: object)
                return false
            }else{
                object.view.endEditing(true)
                return true
            }
        }
        else {
            object.view.endEditing(true)
            return true
        }
        
    }
    
    //MARK:-   Validate : Forgot Password Form
    
    class func validate(forForgotPassword object: ForgotPasswordVC) -> Bool {
        
        if ValidationRules.isBlank(object.emailTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmail.description, sender: object)
            return false
        } else if ValidationRules.isValid(email: object.emailTxtFld.text!) {
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else {
            object.view.endEditing(true)
            return true
        }
    }
    
    //MARK:-   Validate : Redeem Promocode Form
    
    class func validate(forPromoCode object: PromoCodeViewController) -> Bool {
        
        if ValidationRules.isBlank(object.emailTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmail.description, sender: object)
            return false
        } else if ValidationRules.isValid(email: object.emailTxtFld.text!) {
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.pointsTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Please enter points.").description, sender: object)
            return false
        }else {
            object.view.endEditing(true)
            return true
        }
    }
    
    //MARK:-   Validate : Contact Us Form
    
    class func validate(forMessage object: ContactUsViewController) -> Bool {
        
        if ValidationRules.isBlank(object.messageTxtVw) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Please enter message.").description, sender: object)
            return false
        } else {
            object.view.endEditing(true)
            return true
        }
    }
    
    //MARK:-   Validate : Profile Form
    
    class func validate(foProfile object: ProfileViewController) -> Bool {
        
        if ValidationRules.isBlank(object.nameTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyName.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.emailTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyEmail.description, sender: object)
            return false
        } else if ValidationRules.isValid(email: object.emailTxtFld.text!) {
            Global.showAlert(withMessage: ValidationError.OfType.validEmail.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.postCodeTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Post code can't be blank.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.addressTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Address can't be blank.").description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.phoneNumberTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Phone number is required and can't be empty").description, sender: object)
            return false
        } else if object.phoneNumberTxtFld.text!.count < 10 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Phone number should be 10 to 16 digit long.").description, sender: object)
            return false
        } else if object.ageBtn.isSelected && (object.uploadImageVw.image == nil) {
            Global.showAlert(withMessage:ValidationError.OfType.errorWithMessage(message: "Please choose valid id for age confirmation.").description, sender: object)
            return false
        } else if !ValidationRules.isBlank(object.trouserTxtFld){
            if ValidationRules.isBlank(object.trouserLenghtTxtFld){
                Global.showAlert(withMessage:ValidationError.OfType.errorWithMessage(message: "Please choose trouser length.").description, sender: object)
                return false
            }else{
                object.view.endEditing(true)
                return true
            }
        }
        else {
            object.view.endEditing(true)
            return true
        }
    }
    
    //MARK:-   Validate : Change Password Form
    
    class func validate(foChangePassword object: ChangePasswordViewController) -> Bool {
        
        if ValidationRules.isBlank(object.oldPasswordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyOldPassword.description, sender: object)
            return false
        } else if ValidationRules.isBlank(object.newPasswordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.emptyNewPassword.description, sender: object)
            return false
        }else if (object.newPasswordTxtFld.text ?? "").count < 4 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        } else if (object.newPasswordTxtFld.text ?? "").count > 15 {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Password should be 4 to 15 characters long.").description, sender: object)
            return false
        }
        else if ValidationRules.isBlank(object.confirmPasswordTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Confirm password can't be blank.").description, sender: object)
            return false
        } else if object.newPasswordTxtFld.text != object.confirmPasswordTxtFld.text {
            Global.showAlert(withMessage: ValidationError.OfType.emptyConfirmPassword.description, sender: object)
            return false
        } else {
            object.view.endEditing(true)
            return true
        }
    }
    
    //MARK:-   Validate : Redeem Code Form
    
    class func validate(forRedeemCode object: PaymentViewController) -> Bool {
        
        if ValidationRules.isBlank(object.codeTxtFld) {
            Global.showAlert(withMessage: ValidationError.OfType.errorWithMessage(message: "Please enter your promo code.").description, sender: object)
            return false
        }else {
            object.view.endEditing(true)
            return true
        }
    }
    
}
