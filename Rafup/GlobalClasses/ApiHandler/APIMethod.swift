//
//  APIMethod.swift
//  My Life
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import Foundation

indirect enum API:String {
    
    case staticURL          = ""
    case terms              = "app-terms"
    case privacy            = "app-privacy"
    case login              = "Login"
    case signup             = "UserRegister"
    case logout             = "Logout"
    case forgot             = "ForgotPassword"
    case tiers              = "GetTier"
    case productsWithTier   = "GetProductsUnderTier"
    case products           = "GetProductList"
    case productDetail      = "GetProductDetail"
    case buyTicket          = "RegisterParticipent"
    case questionList       = "GetQuestionList"
    case sumitQuestion      = "AddUserAnswer"
    case history            = "ResultList"
    case historyDetail      = "ResultDetail"
    case consolation        = "GetConsolationListForUser"
    case consolationDetail  = "GetConsolationProductList"
    case wheelResult        = "AddConsolationResult"
    case consolationResult  = "GetSingleConsolationDetail"
    case redeeemPromoCode   = "RedeemPromoCode"
    case sharePoints        = "SharePoints"
    case contactUs          = "ContactUs"
    case updateProfile      = "Profile"
    case userProfile        = "GetUserDetail"
    case changePassword     = "ChangePassword"
    case bestFit            = "GetShoeFitBestFit"
    case promoCodeStatus    = "GetPromocodeStatus"
    case showResult         = "GetQuestionStatusByProductId"
    case makePayment        = "MakePayment"
    case generateClientToken = "generateClientToken"
}


extension API : APIRequirement {
    
    static let kSimulatorDeviceID = "7008f7e119eda6c859886c39347ee09ddad7e573"
    
    static var baseURL: String {
        #if DEBUG
        //return "http://192.168.0.219:8181/RafUpProd/"
        return "https://906h6x3onb.execute-api.eu-west-2.amazonaws.com/POC/rafup"
        #else
        return "https://906h6x3onb.execute-api.eu-west-2.amazonaws.com/POC/rafup"
        #endif
    }
    
    var apiHeader: [String : String]! {
        return Constants.kHeaders
    }
    
    var imagePath: String {
        return "\(API.baseURL)assets/uploads/users/"
    }
    
    var apiPath: String {
        return "\(API.baseURL)"
    }
    
    var methodPath: String {
        return self.rawValue
    }
    
    func finalParameters(from parameters: [String : Any]) -> [String : Any] {
        let finalParameters = ["data" : parameters, "method": self.methodPath] as [String : Any]
        
        return finalParameters //lastParameters
    }
    
    func finalHeader(from parameters: [String : String]) -> [String : String] {
        
        let finalHeader = parameters
        return finalHeader //lastHeader
    }
    
    func tokenDidExpired() {
        DispatchQueue.main.async {
             Constants.kAppDelegate.clearAppOnLogout() //logout()
        }
    }
}
