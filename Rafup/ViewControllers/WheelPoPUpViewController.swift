//
//  WheelPoPUpViewController.swift
//  Rafup
//
//  Created by Ashish on 24/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

enum WheelResult {
    case retry
    case won
    case lose
}

class WheelPoPUpViewController: UIViewController {

     // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var resultVw: ConfettiView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productTypeLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var parentedViewController: UIViewController?
    var resultType:WheelResult?
    var productDetail = ProductModel()
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        switch self.resultType {
        case .retry?:
            self.titleLbl.text = "OOP's!!!"
            self.resultLbl.text = "Please retry again"
            self.imageVw.image = #imageLiteral(resourceName: "logo")
            
        case .won?:
            self.resultLbl.text = "You Won"
            self.imageVw.setImageWithURL(url: self.productDetail.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default"), contentMode: self.imageVw.contentMode)
            self.resultVw.isMultiImages = true
            self.resultVw.startConfetti()
            
        case .lose?:
            self.titleLbl.text = "Sorry!!!"
            self.resultLbl.text = "You Lose"
            self.imageVw.image = #imageLiteral(resourceName: "Sad_Face_Emoji")
            
        case .none:
            break;
        }
        
        
        
        if (productDetail.consolationType == "ticket"){
            self.productNameLbl.text =  productDetail.ticketName
            
            if(productDetail.ticketName == "Bronze"){
                self.imageVw.image      = #imageLiteral(resourceName: "bronzeM")
            }else if(productDetail.ticketName == "Silver"){
                self.imageVw.image      = #imageLiteral(resourceName: "silver")
            }else if(productDetail.ticketName == "Gold"){
                self.imageVw.image     = #imageLiteral(resourceName: "gold")
            }else if(productDetail.ticketName == "Platinum"){
                self.imageVw.image      = #imageLiteral(resourceName: "platinum")
            }else{
                self.imageVw.image     = #imageLiteral(resourceName: "bronze")
            }
            
            self.productTypeLbl.isHidden = true
        }else if (productDetail.consolationType == "point"){
            self.productNameLbl.text = "Earn point: \(productDetail.consolation_Point ?? 0)"
            self.imageVw.image = #imageLiteral(resourceName: "eran-point")
            self.productTypeLbl.isHidden = true
        }else{
            self.productNameLbl.text = self.productDetail.brand ?? ""
            if  self.productNameLbl.text != "" {
                self.productNameLbl.text = ( self.productDetail.productName ?? "") + (" - \(self.productNameLbl.text ?? "")")
            } else {
                self.productNameLbl.text = self.productDetail.productName ?? ""
            }
            self.productTypeLbl.isHidden = false
            self.productTypeLbl.text = self.productDetail.productType
        }
    }
    
     // MARK: -  Dismiss ViewController Methods.
    func dismissViewController() {
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            self.view.layoutIfNeeded()
        }) { (success) in
            self.dismiss(animated: false, completion: {
            })
        }
        self.view.layoutIfNeeded()
    }

    // MARK: -  IBAction Methods.
    @IBAction func didTapDismissButton(_ sender: UIButton) {        
        self.dismissViewController()
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

