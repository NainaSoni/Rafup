//
//  ConsolationViewController.swift
//  Rafup
//
//  Created by Ashish on 20/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ConsolationViewController: UIViewController {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var segmentVw: UISegmentedControl!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var currentArray        = [ConsolationModel]()
    var openArray           = [ConsolationModel]()
    var completedArray      = [ConsolationModel]()

    
    var refreshControl = UIRefreshControl()
    var isNotReloadFromHistory = false
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action:#selector(action), for: UIControl.Event.valueChanged)
        tableVw.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitailView()
        // Get Open Consultions Contest
        if (isNotReloadFromHistory == false){
            self.apiCallForConsolutions(isOpen: true)
        }
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        self.setNavigation(title: "Loyalty Points")
        self.navigationController?.removeBackButtonTitle()
        self.hideNavigationBarBottomLine()
        self.setTopNavigation(for: [.leftMenu])
        
        let font = UIFont.boldSystemFont(ofSize: 18)
        
        //SegmentController selected title text color
        self.segmentVw.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: font], for: UIControlState.selected)
        
        //SegmentController default title text color
        self.segmentVw.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: font], for: UIControlState.normal)
        
        //Set delegate and datasource of tableVw
        tableVw.delegate = self
        tableVw.dataSource = self
        
        tableVw.reloadData()
        
        DispatchQueue.main.async {
         self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
        
    }
    @objc func action(){
        switch segmentVw.selectedSegmentIndex {
        case 0:
            //===========================
            //           Open
            //===========================
           self.apiCallForConsolutions(isOpen: true)
        case 1:
            //===========================
            //           Completed
            //===========================
            self.apiCallForConsolutions(isOpen: false)
        default:
            break;
        }
        
    }
    
    // MARK: -  Model Creation Methods.
    func createData(isOpen:Bool, data:[ConsolationModel]) {
        
        if isOpen {
            //===========================
            //           Open
            //===========================
            self.openArray = data
            self.currentArray = self.openArray
            
        } else {
            //===========================
            //        Completed
            //===========================
            self.completedArray = data
            self.currentArray = self.completedArray
        }
        
        DispatchQueue.main.async {
            self.tableVw.reloadData({
                self.tableVw.setContentOffset(CGPoint.zero, animated: true)
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSegmentVwController(_ sender: UISegmentedControl) {
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            //===========================
            //           Open
            //===========================
            
            self.apiCallForConsolutions(isOpen: true)
         
        case 1:
            //===========================
            //        Completed
            //===========================
           
            self.apiCallForConsolutions(isOpen: false)
            
        default:
            break;
        }
        
    }
    

    // MARK: -  IBAction Methods.
    
    
    // MARK: -  Memory warning and handling Method.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    @IBAction func unwindFromConsolationResult(_ sender : UIStoryboardSegue){
        if sender.source is ConsolationResultViewController{
            self.isNotReloadFromHistory = true
        }
    }
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension ConsolationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentArray.count == 0 {
            self.errorLbl.isHidden = false
        } else {
            self.errorLbl.isHidden = true
        }
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: ConsolationCell.className, for: indexPath) as! ConsolationCell
        
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
        
        if currentArray.count > indexPath.row {
            let model = self.currentArray[indexPath.row]
            
            cell.imageVw.setImageWithURL(url: model.image ?? "", placeholder: #imageLiteral(resourceName: "background_default") ,contentMode:cell.imageVw.contentMode)
            
            cell.titleLbl.text      = model.name ?? ""
            cell.discreptionLbl.text = model.descriptions ?? ""
            
            if self.segmentVw.selectedSegmentIndex == 0 {
                //===========================
                //           Open
                //===========================
                //
                cell.subTitleLbl.text = "You need \(model.point ?? 0) points to enter"
            } else {
                //===========================
                //        Completed
                //===========================
                
                cell.subTitleLbl.text = "Already Played" // You \(model.result): \(model.product)
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentArray.count > indexPath.row {
            if self.segmentVw.selectedSegmentIndex == 0 {
                //===========================
                //           Open
                //===========================
                self.isNotReloadFromHistory = false
                if let user = UserProfileModel.getUserLogin(), (user.points ?? 0) >= (currentArray[indexPath.row].point ?? 0) {
                    if let wheelVC = self.storyboard?.instantiateViewController(withIdentifier: ConsolationWheelViewController.className) as? ConsolationWheelViewController {
                        wheelVC.consolation = currentArray[indexPath.row]
                        wheelVC.index = indexPath.row
                        self.navigationController?.pushViewController(wheelVC, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: ConstantsMessages.kPointError)
                    }
                }
            } else {
                //===========================
                //        Completed
                //===========================
                self.isNotReloadFromHistory = true
                if let resultVC = self.storyboard?.instantiateViewController(withIdentifier: ConsolationResultViewController.className) as? ConsolationResultViewController {
                    resultVC.consolation = currentArray[indexPath.row]
                    self.navigationController?.pushViewController(resultVC)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 200
        return UITableViewAutomaticDimension
    }
    
}

// MARK: -  API Calling Methods.
extension ConsolationViewController {
    
    func apiCallForConsolutions(isOpen:Bool) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId": user.id ?? 0,
                               "StatusType": isOpen ? "open" : "completed"
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetConsolutionContest(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        var datasModel = [ConsolationModel]()
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            for items in datas {
                                datasModel.append(ConsolationModel.init(fromDictionary: items))
                            }
                        }
                        self.createData(isOpen: isOpen, data: datasModel)
                        
                        DispatchQueue.main.async {
                                self.refreshControl.endRefreshing()
                            
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

class ConsolationCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var discreptionLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
   
    // MARK: -  Variable Declaration.
    var isGradientAdded = false
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
