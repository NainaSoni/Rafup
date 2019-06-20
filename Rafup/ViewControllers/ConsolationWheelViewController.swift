//
//  ConsolationWheelViewController.swift
//  Rafup
//
//  Created by Ashish on 21/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import SpinWheelControl

class ConsolationWheelViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var spinningWheel: SpinWheelControl!
    @IBOutlet weak var btnSpin: UIButton!
    @IBOutlet weak var lblPoint: UILabel!
    
    // MARK: -  Variable Declaration.
    var consolation = ConsolationModel()
    var wheelProductsArray  = [ProductModel]()
    var index:Int?
    var colorPalette: [UIColor] = [#colorLiteral(red: 0.9607843137, green: 0.6941176471, blue: 0.0862745098, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.2274509804, green: 0.9254901961, blue: 0.3294117647, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 0.1843137255, green: 0.3607843137, blue: 0.9215686275, alpha: 1), #colorLiteral(red: 0.3607843137, green: 1, blue: 0.7803921569, alpha: 1), #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)]
    var isAlertWarning : Bool = false
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add observer for get spein stop index.
        self.spinningWheel.addTarget(self, action: #selector(self.spinWheelDidChangeValue), for: UIControlEvents.valueChanged)
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Consolation Prize")
        self.navigationController?.removeBackButtonTitle()
        
        //Set delegate and datasource of tableVw
        tableVw.delegate = self
        tableVw.dataSource = self
        
        tableVw.reloadData()
        
        DispatchQueue.main.async {
            //Set delegate of spinWheel
            self.spinningWheel.dataSource = self
            
            self.spinningWheel.reloadData()
            
            if let user = UserProfileModel.getUserLogin() {
                self.lblPoint.text = String.init(format: "%i", user.points)
            }
            
        }
        
        self.apiCallForGetConsolationProducts()
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSpinButton(_ UIButton: Any) {
        let btn = UIButton as! UIButton
        self.spinningWheel.randomSpin()
        btn.isUserInteractionEnabled = false
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

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension ConsolationWheelViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wheelProductsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: ConsolationPrizeCell.className, for: indexPath) as! ConsolationPrizeCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        //===========================
        //        SetUp Cell
        //===========================
        
        cell.imageVw.image =  #imageLiteral(resourceName: "background_default")
        
        if !cell.isGradientAdded {
            DispatchQueue.main.async {
                cell.imageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: (cell.imageVw.height/2), width: cell.imageVw.width, height: (cell.imageVw.height/2)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
                cell.isGradientAdded = true
            }
        }
        
        cell.backgroundVw.backgroundColor = colorPalette[indexPath.row]
        
        if wheelProductsArray.count > indexPath.row {
            let model = wheelProductsArray[indexPath.row]
            
            if (model.consolationType == "ticket"){
                cell.titleLbl.text = "Ticket"
                cell.lblPrice.text = model.ticketName
                cell.lblSize.isHidden = true
                
                if(model.ticketName == "Bronze"){
                    cell.imageVw.image      = #imageLiteral(resourceName: "bronzeM")
                }else if(model.ticketName == "Silver"){
                    cell.imageVw.image      = #imageLiteral(resourceName: "silver")
                }else if(model.ticketName == "Gold"){
                    cell.imageVw.image     = #imageLiteral(resourceName: "gold")
                }else if(model.ticketName == "Platinum"){
                    cell.imageVw.image      = #imageLiteral(resourceName: "platinum")
                }else{
                    cell.imageVw.image     = #imageLiteral(resourceName: "bronze")
                }
            }else if (model.consolationType == "point"){
                cell.titleLbl.text = "Point"
                cell.lblPrice.text = "Earn point: \(model.consolation_Point ?? 0)"
                cell.lblSize.isHidden = true
                cell.imageVw.image      = #imageLiteral(resourceName: "eran-point")
            }else{
                cell.imageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default") ,contentMode:cell.imageVw.contentMode)
                cell.titleLbl.text = model.brand ?? ""
                
                if cell.titleLbl.text != "" {
                    cell.titleLbl.text = (cell.titleLbl.text ?? "") + (" - \(model.productName ?? "")")
                } else {
                    cell.titleLbl.text = model.productName ?? ""
                }
                
                cell.lblPrice.text = "£ " + "\((model.retailPrice ?? 0.0).clean)" + ", " + "\(model.productType ?? "")"
                
                if ((model.productType != ConstantsKey.kTrouser) && (model.productType != ConstantsKey.kSkirt) && (model.productType != ConstantsKey.kJeans && (model.productType != ConstantsKey.kAccessory))){
                    cell.lblSize.text = "Size: \(model.size ?? "")"
                }else{
                    if (model.productType != ConstantsKey.kAccessory){
                        cell.lblSize.isHidden = false
                        cell.lblSize.text = "Size: \(model.size ?? "")" + ", Length : " + "\(model.length ?? "")"
                    }else{
                        cell.lblSize.isHidden = true
                    }
                }
            }
            
            cell.lblGender.text = model.gender == "Both" ? "Product for male and female" : "Product for " + (model.gender ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if wheelProductsArray.count > indexPath.row {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - SpinWheelControlDelegate, SpinWheelControlDataSource Methods.
extension ConsolationWheelViewController: SpinWheelControlDataSource, SpinWheelControlDelegate {
    
    func numberOfWedgesInSpinWheel(spinWheel: SpinWheelControl) -> UInt {
        return UInt(self.wheelProductsArray.count)
    }
    
    func wedgeForSliceAtIndex(index: UInt) -> SpinWheelWedge {
        let wedge = SpinWheelWedge()
        
        if colorPalette.count > Int(index) {
            wedge.shape.fillColor = colorPalette[Int(index)].cgColor
        } else {
            let colour = UIColor.random()
            colorPalette.append(colour)
            wedge.shape.fillColor = colour.cgColor
        }
        
        
        if wheelProductsArray.count > index {
            let model = wheelProductsArray[Int(index)]
            if (model.consolationType == "ticket"){
                wedge.label.text = "Ticket"
            }else if (model.consolationType == "point"){
                wedge.label.text = "Point"
            }else{
                wedge.label.text = model.productName ?? ""
            }
        }
        
        wedge.label.adjustsFontSizeToFitWidth = false
        wedge.label.numberOfLines = 0
        wedge.label.textAlignment = .left
        wedge.label.font = UIFont(font: .alNileBold, size: 15.0)
        return wedge
    }
    
    @objc func spinWheelDidChangeValue(sender: AnyObject) {
        print("Value changed to " + String(self.spinningWheel.selectedIndex))
        
        //Check if retry then play again popup show.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.apiCallForWheelResult(index: self.spinningWheel.selectedIndex)
        }
    }
}

// MARK: -  API Calling Methods.
extension ConsolationWheelViewController {
    
    func apiCallForGetConsolationProducts() {
        let parameters = [ "ConsolationId": self.consolation.id ?? 0
            ] as [String : Any]
        Global.showLoadingSpinner()
        ApiManager.apiCallForGetConsolutionDetail(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [[String:Any]] {
                        if (datas.count == 0){
                            DispatchQueue.main.async {
                               
                                self.presentAlertWith(message: ConstantsMessages.kConsolationProductClose, oktitle: "Ok", okaction: {
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                            }
                        }else{
                            for items in datas {
                                self.wheelProductsArray.append(ProductModel.init(fromDictionary: items))
                            }
                        }
                        
                    }
                    DispatchQueue.main.async {
                        if  self.wheelProductsArray.count > 1 {
                            self.spinningWheel.isUserInteractionEnabled = false
                        }
                        self.tableVw.reloadData()
                        self.spinningWheel.reloadData()
                    }
                }
            }
        }
    }
    
    func apiCallForWheelResult(index:Int) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId"        : user.id ?? 0,
                               "ConsolationId" : consolation.id ?? 0,
                               "ProductId"     : wheelProductsArray[index].productId ?? 0,
                               "TicketId"      : wheelProductsArray[index].ticketId ?? 0,
                               "Point"         : consolation.point ?? 0,
                               "ConsolationType" : wheelProductsArray[index].consolationType ?? "",
                               "Consolation_Point" : wheelProductsArray[index].consolation_Point ?? 0,
                               "TicketExpiryDate" : wheelProductsArray[index].ticketExpiryDate ?? "",
                               "TierId" : wheelProductsArray[index].tierId ?? 0,
                               "Email" : user.email ?? "",
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForSumitWheelResult(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        //Change consolationVC array object and push to popup
                           self.apiCallForUserProfile()
                            DispatchQueue.main.async {
                                
                                if let popupVC = self.storyboard?.instantiateViewController(withIdentifier: WheelPoPUpViewController.className) as? WheelPoPUpViewController {
                                    popupVC.parentedViewController = self
                                    popupVC.resultType = .won
                                    popupVC.productDetail = self.wheelProductsArray[index]
                                    popupVC.providesPresentationContextTransitionStyle = true
                                    popupVC.definesPresentationContext = true
                                    popupVC.modalPresentationStyle = .overCurrentContext
                                    popupVC.modalTransitionStyle = .crossDissolve
                                    self.present(popupVC, animated: true, completion: nil)
                                    self.wheelProductsArray = []
                                    self.apiCallForGetConsolationProducts()
                                }
                        }
                    }
                }
            }
        }
    }

    
    
    func apiCallForUserProfile() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id" : user.id ?? 0
                ] as [String : Any]
            ApiManager.apiCallForGetUserProfile(parameters: parameters) { (responseObject, error) in
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [String:Any] {
                        user.updateUserAndSave(attributes: datas)
                    }
                    if let user = UserProfileModel.getUserLogin() {
                        DispatchQueue.main.async {
                            self.lblPoint.text = String.init(format: "%i", user.points)
                            self.btnSpin.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
    }
}




//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UITableViewCell.
//=========================================================================================================
//=========================================================================================================

class ConsolationPrizeCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblGender: UILabel!
    // MARK: -  Variable Declaration.
    var isGradientAdded = false
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
