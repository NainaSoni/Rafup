//
//  PaymentViewController.swift
//  Rafup
//
//  Created by Ashish on 10/10/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree


class PaymentViewController: UIViewController{

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var codeTxtFld: CustomTextFieldAnimated!
    
    
    // MARK: -  Variable Declaration.
    var product:ProductModel?
    var productSize:String?
    var productLength:String?
    var Gender:String?
    
    
    // MARK: -  Braintree.
    var braintreeClient: BTAPIClient?
    //var btnc: UINavigationController?
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Payment")
        self.navigationController?.removeBackButtonTitle()
        
        DispatchQueue.main.async {
            //Set bottom line to textfield.
            self.codeTxtFld.bottomLine  = true
            self.codeTxtFld.setPlaceHolderTextColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapRedeemCodeButton(_ sender: UIButton) {
        if ValidationHandel.validate(forRedeemCode: self) {
            self.apiCallForRedeemPromoCode()
        }
    }
    
    @IBAction func didTapBuyButton(_ sender: UIButton) {
        //uncomment for payment section
        //self.apiCallForGetToken()
        
        //byPass
        if let model = self.product {
            self.apiCallForPaticipate(product: model)
        }
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                self.apiCallForSendNonceToServer(paymentMethodNonce: (result.paymentMethod?.nonce)!)
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
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
extension PaymentViewController {
    
    func apiCallForPaticipate(product:ProductModel) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId" : (user.id ?? 0) as Any,
                               "ProductId" : (product.productId ?? 0) as Any,
                               "SelectedSize" : (self.productSize ?? "") as Any,
                               "SelectedLength" : (self.productLength ?? "") as Any,
                               "Gender" : (self.Gender ?? "") as Any,
                               "Price" : (product.ticketPrice ?? 0) as Any
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForBuyTicket(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [ String:Any] {
                            
                            DispatchQueue.main.async {
                                self.presentAlertWith(message: responseObjects["ResponseMessage"] as! String, oktitle: "Play quiz", okaction: {
                                    if let questionVc = self.storyboard?.instantiateViewController(withIdentifier: QuestionsViewController.className) as? QuestionsViewController {
                                        questionVc.productId = product.productId
                                        questionVc.ticketId = datas["TicketId"] as! Int
                                        self.navigationController?.pushViewController(questionVc, animated: true)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.presentAlertWith(message: ConstantsMessages.kParticipateError, oktitle: "Ok", okaction: {
                    self.navigationController?.popToRootViewController(animated: true)
                }, notitle: "Cancel", noaction: nil)
            }
        }
    }
    
    func apiCallForSendNonceToServer(paymentMethodNonce: String) {
        if let user = UserProfileModel.getUserLogin() {
            if let model = self.product {
                let parameters = ["UserId" : (user.id ?? 0) as Any,
                                  "ProductId" : (model.productId ?? 0) as Any,
                                  "amount" : model.ticketPrice ?? 0,
                                  "nonce" : paymentMethodNonce
                    ] as [String : Any]
                Global.showLoadingSpinner()
                ApiManager.apiCallForSendNonce(parameters: parameters) { (responseObject, error) in
                    Global.dismissLoadingSpinner()
                    if (error == nil) {
                        if let responseObjects = responseObject {
                            print(responseObjects)
                            self.apiCallForPaticipate(product: model)
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.presentAlertWith(message: ConstantsMessages.kParticipateError, oktitle: "Ok", okaction: {
                        self.navigationController?.popToRootViewController(animated: true)
                    }, notitle: "Cancel", noaction: nil)
                }
            }
        }
    }
    
    func apiCallForGetToken()  {
            let parameters = [:] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetClientToken(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? String {
                           // return datas
                            self.showDropIn(clientTokenOrTokenizationKey: datas)
                        }
                    }
                }
            }
     }
    
    func apiCallForRedeemPromoCode() {
        if let user = UserProfileModel.getUserLogin() {
            if let model = self.product {
            let parameters = [ "userId" : user.id ?? 0,
                               "productId" : model.productId ?? 0,
                               "promoCode" : self.codeTxtFld.text ?? "",
                               "tierId" : model.tierId ?? 0,
                               
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForRedeemPromoCode(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                         print(responseObjects)
                         self.apiCallForPaticipate(product: model)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.presentAlertWith(message: ConstantsMessages.kParticipateError, oktitle: "Ok", okaction: {
                    self.navigationController?.popToRootViewController(animated: true)
                }, notitle: "Cancel", noaction: nil)
            }
        }
        }
    }
}
