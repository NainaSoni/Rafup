//
//  ApiManager.swift
//  Underwrite-it
//
//  Created by Ashish on 22/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ApiManager: NSObject {

    //MARK:-   API : Login
    
    class func apiCallForLogin(parameters: [String : String],isRemember:Bool, completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.login.request(with: parameters, completionHandler: { (jsonObject, error) in
            if (error == nil) {
                if let responseJson = jsonObject {
                    
                    //=========================
                    //     Save User Info
                    //=========================
                    if let datas = responseJson["Data"] as? [String:Any] {
                        let model =  UserProfileModel(fromDictionary:datas)
                        model.saveUser()
                    }
                    
                    //=========================
                    //      Move into App
                    //=========================
                    DispatchQueue.main.async {
                        Constants.kAppDelegate.applicationLoggedInSuccessfully(nil, animated: true)
                    }
                }
                
                completionHandler?(jsonObject, error)
                
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        })
    }
    
     //MARK:-   API : Logout
    
    class func apiCallForLogOut(parameters: [String : Any], completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.logout.request(with: parameters, completionHandler: { (jsonObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                DispatchQueue.main.async {
                    Constants.kAppDelegate.clearAppOnLogout(showAlert: false)
                    completionHandler?(jsonObject, error)
                }
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        })
    }
    
    //MARK:-   API : Register
    
    
    class func apiCallForSignUp(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.signup.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                
                if let responseJson = responseObject {
                    
                    //=========================
                    //     Save User Info
                    //=========================
                    if let datas = responseJson["Data"] as? [String:Any] {
                        let model =  UserProfileModel(fromDictionary:datas)
                        model.saveUser()
                    }
                    
                    //=========================
                    //      Move into App
                    //=========================
                    DispatchQueue.main.async {
                        Constants.kAppDelegate.applicationLoggedInSuccessfully(nil, animated: true)
                    }
                }
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Forgot Password
    
    class func apiCallForForgotPassword(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.forgot.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Tiers
    
    class func apiCallForTiers(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.tiers.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Products Under Tier
    
    class func apiCallForGetProductsWithTiers(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.products.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get All Featured Products.
    
    class func apiCallForGetFeaturedProducts(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.products.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Product Detail.
    
    class func apiCallForGetProductDetail(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.productDetail.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Participate User.
    
    class func apiCallForBuyTicket(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.buyTicket.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Client Token.
    
    class func apiCallForGetClientToken(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.generateClientToken.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Send Nonce to server.
    
    class func apiCallForSendNonce(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.makePayment.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Questions.
    
    class func apiCallForGetQuestions(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.questionList.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Submit Questions.
    
    class func apiCallForSubmitQuestions(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.sumitQuestion.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Show Result.
    
    class func apiCallForShowResult(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.showResult.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get History For Participation.
    
    class func apiCallForGetHistory(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.history.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get History Detail.
    
    class func apiCallForGetHistoryDetail(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.historyDetail.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Consolution Contests.
    
    class func apiCallForGetConsolutionContest(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.consolation.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Consolution Detail Contests.
    
    class func apiCallForGetConsolutionDetail(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.consolationDetail.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Submit Consolution Contests Result.
    
    
    class func apiCallForSumitWheelResult(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.wheelResult.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Get Consolution Result.
    
    
    class func apiCallForGetConsolutionResult(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.consolationResult.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Redeem Code.
    
    
    class func apiCallForRedeemPromoCode(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.redeeemPromoCode.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Share Points.
    
    
    class func apiCallForSharePoints(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.sharePoints.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Contact Us .
    
    
    class func apiCallForContactUs(parameters:[String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.contactUs.request(with:  parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                }
            }
        }
    }
    
    //MARK:-   API : Update Profile
    
    class func apiCallForUpdateProfile(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.updateProfile.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Get User Profile
    
    class func apiCallForGetUserProfile(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.userProfile.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Change Password
    
    class func apiCallForChangePassword(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.changePassword.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Best Fit, Shoe, Featured
    
    class func apiCallForGetBestFit(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.bestFit.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
    
    //MARK:-   API : Promo code status
    
    class func apiCallForPromoCodeStatus(parameters: [String : Any] ,completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) {
        API.promoCodeStatus.request(with: parameters) { (responseObject, error) in
            if (error == nil) {
                completionHandler?(responseObject, error)
            } else {
                DispatchQueue.main.async {
                    Global.dismissLoadingSpinner()
                    
                }
            }
        }
    }
}
