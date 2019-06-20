//
//  LandingViewController.swift
//  Rafup
//
//  Created by Ashish on 04/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var featureImageVw: UIImageView!
    @IBOutlet weak var featureLbl: UILabel!
    @IBOutlet weak var featurePriceLbl: UILabel!
    @IBOutlet weak var ticketCountLbl: UILabel!
    @IBOutlet weak var bestFitImageVw: UIImageView!
    @IBOutlet weak var bestFitLbl: UILabel!
    @IBOutlet weak var bestShoeImageVw: UIImageView!
    @IBOutlet weak var bestShoeLbl: UILabel!
    
    
    // MARK: -  Variable Declaration.
    var bestFit:  BestFitModel?
    var bestShoe: BestFitModel?
    var featured: ProductModel?
    
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         setupInitailView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Make navigation bar hide.
        self.hideNavigationBar()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Set Gradient to button
        DispatchQueue.main.async {
             // Add Image view bootom up gradient
            self.featureImageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: 0, width: self.featureImageVw.width, height: (self.featureImageVw.height)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
            self.bestFitImageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: 0, width: self.featureImageVw.width, height: (self.featureImageVw.height)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
            self.bestShoeImageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: 0, width: self.featureImageVw.width, height: (self.featureImageVw.height)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
        }
        
        self.setUpUI()
        self.apiCallForBestFit()
    }
    
    // MARK:- Setup UI Method.
    func setUpUI() {
        
        self.featurePriceLbl.text = " "
        self.ticketCountLbl.text = " "
        
        if let model = self.bestFit {
            self.bestFitImageVw.setImageWithURL(url: model.displayUrl ?? "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: self.bestFitImageVw.contentMode)
        }
        
        if let model = self.bestShoe {
            self.bestShoeImageVw.setImageWithURL(url: model.displayUrl ?? "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: self.bestShoeImageVw.contentMode)
        }
        
        if let model = self.featured {
            self.featureImageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: self.featureImageVw.contentMode)
            self.featurePriceLbl.text = "£ " + "\(model.retailPrice ?? 0.0)"
            self.ticketCountLbl.text = "\(model.availableTickets ?? 0)"
        }
    }

    // MARK: -  IBAction Methods.
    @IBAction func didTapFeatureRaffleButton(_ sender: UIButton) {
    }
    @IBAction func bestFitOfTheWeekBtnPress(_ sender: Any) {
        if let model = self.bestFit {
            let instagramHooks = model.shortCode
            let instagramUrl = NSURL(string: instagramHooks ?? "")
            
            if UIApplication.shared.canOpenURL(instagramUrl! as URL){
                UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
            }else{
                let webURL = URL(string: "https://instagram.com/p/\(instagramHooks ?? "")")!
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func bestShoeOfTheWeekBtnPress(_ sender: Any) {
        if let model = self.bestShoe {
            let instagramHooks = model.shortCode
            let instagramUrl = NSURL(string: instagramHooks ?? "")
            
            if UIApplication.shared.canOpenURL(instagramUrl! as URL){
                UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
            }else{
                let webURL = URL(string: "https://instagram.com/p/\(instagramHooks ?? "")")!
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
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
extension LandingViewController {
    
    func apiCallForBestFit() {
        let parameters = [String:Any]()
       // Global.showLoadingSpinner()
        ApiManager.apiCallForGetBestFit(parameters: parameters) { (responseObject, error) in
           // Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [AnyObject] {
                        for item in datas {
                            if  let dict =  item as? [String: Any]  {
                                if item["Type"] as? String == "BestFit" {
                                    self.bestFit = BestFitModel.init(fromDictionary: dict)
                                } else if item["Type"] as? String == "ShoeFit" {
                                    self.bestShoe = BestFitModel.init(fromDictionary: dict)
                                } else {
                                    self.featured = ProductModel.init(fromDictionary: dict)
                                }
                            }
                        }
                        self.apiCallForProducts()
                    }
                }
            }
        }
    }
    func apiCallForProducts() {
        let parameters = [ "TierId": 0 ,
                           "IsFeatured" : "1",
                           "IsEighteenPlus": "0"
            ] as [String : Any]
        
        Global.showLoadingSpinner()
        ApiManager.apiCallForGetProductsWithTiers(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [[String:Any]] , datas.count > 0{
                        self.featured = ProductModel.init(fromDictionary: datas[0])
                    }
                    DispatchQueue.main.async {
                        self.setUpUI()
                    }
                    
                }
            }
        }
    }
}


