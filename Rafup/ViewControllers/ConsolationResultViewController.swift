//
//  ConsolationResultViewController.swift
//  Rafup
//
//  Created by Ashish on 24/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import MessageUI
class ConsolationResultViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var collectionVw: UICollectionView!
    
    // MARK: -  Variable Declaration.
    var results : ProductModel?
    var resultArr = [ProductModel]()
    var consolation = ConsolationModel()
    let flowLayout = CenterFlowLayout()
    
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performSegue(withIdentifier: "unwindToConsolation", sender: self)
    }
    
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Consolation Result")
        self.navigationController?.removeBackButtonTitle()
        
        //Set delegate and datasource of collectionVw
        collectionVw.delegate = self
        collectionVw.dataSource = self
        collectionVw.reloadData()
        
        // Set CollectionView FlowLayout
        DispatchQueue.main.async {
            let relativeWidth:CGFloat = ((0.135) * (self.collectionVw.width))
            self.flowLayout.minimumLineSpacing = relativeWidth
            self.collectionVw.collectionViewLayout = self.flowLayout
            self.view.layoutIfNeeded()
            self.view.setGradient(colours: [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) , #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)])
        }
        
        self.apiCallForGetConsolationResult()
    }
    
    @objc func contactUsBtnPress() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["officialrafup@gmail.com"])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    // MARK: -  IBAction Methods.

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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension ConsolationResultViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return (results != nil) ? 1 : 0
        return  resultArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationsCell.className, for: indexPath) as! NotificationsCell
        
        cell.contestImageVw.image = AssetsImages.kDefaultBackground
        cell.backgroundVw.startConfetti()
        
        //===========================
        //        SetUp Cell
        //===========================
        self.results = self.resultArr.item(at: indexPath.row)
        if let model = self.results {
            
            cell.btnContactUs.addTarget(self, action: #selector(contactUsBtnPress), for: .touchUpInside)
            if (model.consolationType == "ticket"){
                cell.btnContactUs.isHidden = false
                cell.brandLbl.text = model.tierName + " code is : " + model.promoCode
                
                if(model.tierName == "Bronze"){
                    cell.contestImageVw.image      = #imageLiteral(resourceName: "bronzeM")
                }else if(model.tierName == "Silver"){
                    cell.contestImageVw.image      = #imageLiteral(resourceName: "silver")
                }else if(model.tierName == "Gold"){
                    cell.contestImageVw.image     = #imageLiteral(resourceName: "gold")
                }else if(model.tierName == "Platinum"){
                    cell.contestImageVw.image      = #imageLiteral(resourceName: "platinum")
                }else{
                    cell.contestImageVw.image     = #imageLiteral(resourceName: "bronze")
                }
                cell.productTypeLbl.isHidden = true
            }else if (model.consolationType == "point"){
                cell.btnContactUs.isHidden = false
                cell.brandLbl.text = "Point: \(model.consolation_Point ?? 0)"
                cell.contestImageVw.image      = #imageLiteral(resourceName: "eran-point")
                cell.productTypeLbl.isHidden = true
            }else{
                cell.btnContactUs.isHidden = true
                cell.contestImageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: AssetsImages.kDefaultBackground, contentMode: .scaleAspectFit)
                
                cell.brandLbl.text = model.brand ?? ""
                if cell.brandLbl.text != "" {
                    cell.brandLbl.text = (cell.brandLbl.text ?? "") + (" - \(model.productName ?? "")")
                } else {
                    cell.brandLbl.text = model.productName ?? ""
                }
                cell.productTypeLbl.isHidden = false
                cell.productTypeLbl.text = model.productType ?? ""
            }
            
            switch model.resultStatus ?? "" {
            case "Waiting":
                cell.conetstResultTitleLbl.text = "Declare soon!!!"
                cell.contestResultLbl.text = "\(model.resultStatus ?? "")"
                
            case "Won":
                cell.conetstResultTitleLbl.text = "Congratulations!!!"
                cell.contestResultLbl.text = "You \(model.resultStatus ?? "")"
                cell.backgroundVw.startConfetti()
                
            case "Lose":
                cell.conetstResultTitleLbl.text = "Sorry!!!"
                cell.contestResultLbl.text = "You \(model.resultStatus ?? "")"
                
            default: break
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let relativeWidth:CGFloat = ((0.38) * (self.collectionVw.width))
        let width   = self.collectionVw.width - relativeWidth
        let hieght  = self.collectionVw.height - 100
        return CGSize.init(width: width, height: hieght)
    }
}

// MARK: -  API Calling Methods.
extension ConsolationResultViewController {
    
    func apiCallForGetConsolationResult() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId" :  user.id ?? 0,
                               "ConsolationId" :  consolation.id ?? 0
            ]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetConsolutionResult(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            for items in datas {
                                self.resultArr.append(ProductModel.init(fromDictionary: items))
                            }
                        }
                        DispatchQueue.main.async {
                            self.collectionVw.setContentOffset(CGPoint.init(x: 40, y: 0), animated: true)
                            self.collectionVw.reloadData()
                        }
                    }
                }
            }
        }
    }
}


//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UICollectionViewCell.
//=========================================================================================================
//=========================================================================================================

class NotificationsCell: UICollectionViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var contestTitleLbl: UILabel!
    @IBOutlet weak var contestImageVw: UIImageView!
    @IBOutlet weak var contestResultLbl: UILabel!
    @IBOutlet weak var conetstResultTitleLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var backgroundVw: ConfettiView!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var productTypeLbl: UILabel!
    // MARK: -  Variable Declaration.
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundVw.isMultiImages = true
    }
    
}
