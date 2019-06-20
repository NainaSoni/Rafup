//
//  Constants.swift
//  Fodder
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import CoreLocation

public struct Constants {
    
    static let kAppDelegate         = UIApplication.shared.delegate as! AppDelegate
    static let kUserDefaults        = UserDefaults.standard

    static let kScreenWidth         = UIScreen.main.bounds.width
    static let kScreenHeight        = UIScreen.main.bounds.height
    
    static let kAppDisplayName      = UIApplication.appName
    static let kAppVersion          = UIApplication.shortVersionString
    
    static let kLocationManager     = CLLocationManager()
    static let kCalendar            = Calendar.current

    static let kGoogleAPIKey        = "AIzaSyAL0dhvoIhaXPJ5hJbieNcCR5ybhz_TCj0"
    static let kAPIVersion          = "1.0"
    static let kAuthAPIKey          = "cd5b5206057d79a8bcf5656960606a4a8b53e137c15eba5a96a17830a52ebba9"
    static let kDeviceType          = "ios"
    static let kDeviceModel         = UIDevice.current.type.rawValue
    static let kOSVersion           = UIDevice.iOSVersion
    
    
    static let kHeaders = ["Content-Type": "application/json"]
                          //"Deviceid": kAppDelegate.deviceID]
    
    typealias CompletionHandler = (_ result: Any?, _ error: Error?) -> Void
}

//MARK:- Paypal client id's

//**********---------- Here Paypal client id's for producation and development ----------**********
let payPalClientIdProduction = "AeOgoSaMFIFJzVp3zTMhyZJvP7kvRHajjVfZhd-7CjY4D12miiNaWNIvzDs02qZq2nvs1xPpuvKTGI4C"
let payPalClientIdDevelopment = "AUu2ZUv3Pbuqeib8UCF-RFT1DXZorxKH7BT7WG_O64nJXxfTUGyaj-tUBxFnTPlxVNh2LFGcA8qClNMR"

// MARK: - Web Service Constans Objects.
public struct ApiConstants {
    static let apiTimeoutTime =  60 //Seconds.
}

// MARK: - Storyboard Objects.
public struct Storyboard {
    
    static let kMainStoryboard      = UIStoryboard(name: "Main", bundle: nil)
    static let kHistoryStoryboard   = UIStoryboard(name: "History", bundle: nil)
}

// MARK: - Images Objects.
public struct AssetsImages {
    
    static let kAppIconSmall        = UIImage(named: "AppIcon29x29")
    static let kDefaultUser         = #imageLiteral(resourceName: "user_default")
    static let kDefaultBackground   = #imageLiteral(resourceName: "background_default")
    
    static let kAppLogoNavigation   = UIImage(named: "AppIcon29x29")
    static let kLeftMenuNavigation  = #imageLiteral(resourceName: "menu") // #imageLiteral(resourceName: "sidemenu")
    static let kBack                = #imageLiteral(resourceName: "back_arrow")
    static let kCart                = #imageLiteral(resourceName: "shopping-cart")
    static let kPlay                = #imageLiteral(resourceName: "play")
    
    static let kLogout              = #imageLiteral(resourceName: "logout")
    static let kBell                = #imageLiteral(resourceName: "notification")
}

// MARK: - Colour Objects.
public struct ColourAssest {
    
    static let kSideMenuSelectedCellColour      = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let kSideMenuUnSelectedCellColour    = #colorLiteral(red: 0.9058823529, green: 0.9764705882, blue: 0.937254902, alpha: 1)
}

// MARK: - TableView Cell Identifiers.
public struct Identifiers {
    
    static let kDefaultCell         = "Cell"
    
}

// MARK: - Web Service Constans Objects.
public struct Urls {
    static let tersmsAndCondition  =  "http://www.rafup.co.uk/terms&Condition.html"
    static let privacyAndPolicy    =  "http://rafup.co.uk/privacy-policy.html"
    static let appStoreLink        =  "https://itunes.apple.com/us/app/rafup/id1436477039?ls=1&mt=8"
}

// MARK: - Notification Objects and Keys.
extension Notification.Name {
    /// Used as a namespace for all `Notification` user info dictionary keys.
    public struct Key {
        // Definition:
        public static let kNewOrder = Notification.Name(NotificationKey.kNewOrder)
    }
}

public struct NotificationKey {
    
    static let kNewOrder = "org.app.notification.key.newOrder"
}

// MARK: - ConstantsErrors Objects.
public struct ConstantsErrors {

    static let kNoInternetConnection = NSError(domain: Constants.kAppDisplayName, code: NSURLErrorNotConnectedToInternet, userInfo: [NSLocalizedDescriptionKey: ConstantsMessages.kConnectionFailed])
    
    static let kCancelledFacebook = NSError(domain: Constants.kAppDisplayName, code: 1000000, userInfo: [NSLocalizedDescriptionKey : "You have cancelled logging in with Facebook."])
    
    static let kDeclinedFacebookPermissions = NSError(domain: Constants.kAppDisplayName, code: 1000001, userInfo: [NSLocalizedDescriptionKey : "You  Declined Facebook Permissions."])
    
    static let kSomethingWrong = NSError(domain: Constants.kAppDisplayName, code: 1000002, userInfo: [NSLocalizedDescriptionKey : "Something went wrong\nPlease try again soon!."])

}

// MARK: - Error Messages Objects.
public struct ConstantsMessages {
    
    static let kConnectionFailed    = "looks like there is some problem in your internet connection,\nPlease try again after some time."
    static let kNetworkFailure      = "looks like there is some network error,\nPlease try after some time."
    static let kSomethingWrong      = "Something went wrong\nPlease try again!"
    static let kNoNetworkConnection = "Unable to connect, Please check that you are connected to the internet and try agin."
    
    //==============================
    //     CUSTOM APP MESSAGES
    //==============================
    static let kSucessfullyRegister             = "You are registered successfully"
    static let kLogout                          = "Are you sure you want to logout?"
    static let kCameraPermission                = "This app does not have permission to access the camera"
    static let kParticipate                     = "You had successfully participated in this contest"
    static let kPromoCodeError                  = "Please enter valid promocode"
    static let kForgotPassword                  = "Please check your email we send you an email in response to reset your password instructions."
    static let kProbabilityError               = "Please enter less value from total available tickets."
    static let kParticipateError               = "Please login or signup to buy this product."
    static let kQuestionError                  = "Please choose one option to submit your answer."
    static let kQuestionSubmitted              = "Your answers is successfully submitted."
    static let kRedeemCode                     = "Promocode redeemed successfully."
    static let kSharePoints                    = "Points shared successfully."
    static let kMessage                        = "Your message has been sent successfully."
    static let kEighteenError                  = "To purchase 18+ tickets you will have to complete the account verification in the settings."
    //"To purchase this product please go to settings and complete 18+ verification or ask admin to verify your account."
    
    static let kPointError                     = "You don't have sufficient loyalty points to enter this competition."
    static let kChangePassword                 = "You password is successfully changed."
    
    
    //static let kDownloadMessage                = "Download a new app and register an account for your chance to win amazing products."
    
    static let kDownloadMessage                = "Hey! Download and register an account with this amazing new app which allows you to buy designer garms for cheap"
    static let kLoginError               = "Please login or signup to buy this product."
    static let kAvailableTicketError               = "This ticket is no longer available."
    static let kSizeCheck              = "Please choose size first."
    static let kLengthCheck              = "Please choose length first."
    static let kConsolationProductClose               = "This consolation has been closed."
    
    
}

// MARK: - Key word.
public struct ConstantsKey {
    
    //product name
    static let kTrouser = "Trouser"
    static let kShirt = "Shirt"
    static let kShoes = "Shoes"
    static let kSkirt = "Skirt"
    static let kJeans = "Jeans"
    static let kJacket = "Jacket"
    static let kHoodie = "Hoodie"
    static let kTracksuit = "Tracksuit"
    static let kSweatShirt = "SweatShirt"
    static let kPolo_Shirt = "Polo Shirt"
    static let kTshirt = "Tshirt"
    static let kCoat = "Coat"
    static let kAccessory = "accessory"
}


