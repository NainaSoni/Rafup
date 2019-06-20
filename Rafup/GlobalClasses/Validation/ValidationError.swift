//
//  ValidationErrorType.swift
//  Underwrite-it
//
//  Created by Ashish on 06/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

public class ValidationError: NSObject {

    public enum OfType : Error {
        
        case errorWithMessage(message: String)
        
        case empty
        case emptyEmail
        case emptyPassword
        case emptyOldPassword
        case emptyNewPassword
        case emptyConfirmPassword
        case emptyName
        case emptyUserName
        case emptyMobileCode
        case emptyMobileNumber
        case emptyAddress
        case emptyCity
        case emptyState
        case emptyCountry
        case emptyPostalCode
        case emptyRating

        case termsAndCondition
        
        case validEmail
        case validPassword
        case validConfirmPassword
        case validMobileNumber
        case alreadyExistMobile
        
        case companyName
        case carPlateNo
        case referralCode
       
        case emptyDescription
        
        case emptyReason
        case emptyDate
        case emptyAmount
        
        case emptyDegination
        case emptyJobTitle
        case emptyJobPoints
        case emptyJobDescription
        case emptyCategory
        case emptyKeywords
        case emptyPreferredDay
        case emptyPreferredTime
        case emptyEstComJob
        case emptyRequiredDate
        case emptyEquipment
        case emptyLocation
        case emptyPaypalEmail


    }
}

extension ValidationError.OfType {
    
    var description: String {
        switch self {
            
        case .errorWithMessage(let message):
            return message

        case .empty:
            return "can't be blank."
            
        case .emptyEmail:
            return "Please enter an email address."
        case .emptyPaypalEmail:
            return "Paypal email address can't be blank."
        case .emptyPassword:
            return "Password can't be blank and must be 4 characters long."
            
        case .emptyOldPassword:
            return "Old password can't be blank."
        case .emptyNewPassword:
            return "New password can't be blank and must be at least 4 characters long."
        case .emptyConfirmPassword:
            return "Password and Confirm Password doesn't match."
        case .termsAndCondition:
            return "Please accept terms and conditions."
         
        case .emptyName:
            return "Name can't be blank."
        case .emptyUserName:
            return "User name can't be blank."
            
        case .emptyMobileNumber:
            return "Mobile number is required and can't be empty"
        case .emptyAddress:
            return "Building name or Postal code can't be blank !"
        case .emptyCity:
            return "City can't be blank."
        case .emptyState:
            return "State can't be blank."
        case .emptyCountry:
            return "Country can't be blank."
        case .emptyPostalCode:
            return "Zip code can't be blank."
        case .emptyRating:
            return "Rating can't be empty."
     

        case .validEmail:
            return "Please enter a valid email address."
        case .validPassword:
            return "Password can't be blank and must be minimum 4 characters long."
        case .validConfirmPassword:
            return "Password not match."
            
        case .alreadyExistMobile:
            return "This mobile number already exist."
            
        case .emptyMobileCode:
            return "Mobile code can't be blank."
        case .validMobileNumber:
            return "Please enter 8 digit number !"
            
        case .companyName:
            return "Company name can't be blank."
        case .carPlateNo:
            return "Please enter car plate number."
        case .referralCode:
            return "Please enter referral Code."

            
        case .emptyDescription:
            return "Description can't be blank."

        case .emptyReason:
            return "Reason can't be blank."
        case .emptyDate:
            return "Date can't be blank."

        case .emptyAmount:
            return "Please enter a valid amount."
            
        case .emptyJobTitle:
            return "Job title can't be blank."
        case .emptyJobPoints:
            return "Job point value can't be blank."
        case .emptyJobDescription:
            return "Job description can't be blank."
        case .emptyCategory:
            return "Category can't be blank."
        case .emptyKeywords:
            return "Keywords can't be blank."
        case .emptyPreferredDay:
            return "Preferred day can't be blank."
        case .emptyPreferredTime:
            return "Preferred time can't be blank."
        case .emptyEstComJob:
            return "Estimate time to complete job can't be blank."
        case .emptyRequiredDate:
            return "Required by date can't be blank."
        case .emptyEquipment:
            return "Equipment provided can't be blank."
        case .emptyLocation:
            return "Location can't be blank."
            
        default: return ""
        }
    }
}

extension ValidationError {
    
    public enum Card : Error {
        
        case emptyNickName
        case emptyName
        case emptyCardNo
        case emptyExpMonth
        case emptyExpYear
        case emptyCvv
        case validCardDetails
        
        var description: String {
            switch self {
                
            case .emptyNickName:
                return "Card Nickname can't be blank."
            case .emptyName:
                return "CardHolder Name can't be blank."
            case .emptyCardNo:
                return "Card Number can't be blank."
            case .emptyExpMonth:
                return "Expiry Date can't be blank."
            case .emptyExpYear:
                return "Expiry Date can't be blank."
            case .emptyCvv:
                return "CVV can't be blank."
            case .validCardDetails:
                return "Please enter valid card details."
            }
        }
    }
}
