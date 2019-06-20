//
//  HistoryViewController.swift
//  Rafup
//
//  Created by Ashish on 17/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var segmentVw: UISegmentedControl!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var currentArray        = [ProductModel]()
    var pendingArray        = [ProductModel]()
    var completeArray       = [ProductModel]()
    var refreshControl = UIRefreshControl()
    var isNotReloadFromHistory = false
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        //pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action:#selector(action), for: UIControl.Event.valueChanged)
        tableVw.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitailView()
        // Get Pending history products
        if (isNotReloadFromHistory == false){
            segmentVw.selectedSegmentIndex = 0
            self.apiCallForProducts(isPending: true)
            segmentIndexZeroView()
        }
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "History")
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
        
        //Set delegate and datasource of collectionVw
        collectionVw.delegate = self
        collectionVw.dataSource = self
        collectionVw.reloadData()
        
        
        
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
        
    }
    @objc func action(){
        self.apiCallForProducts(isPending: true)
    }
    
    // MARK: -  Model Creation Methods.
    func createData(isPending:Bool, data:[ProductModel]) {
        
        if isPending {
            //===========================
            //         Pending
            //===========================
            self.pendingArray = data
            self.currentArray = self.pendingArray
            
            DispatchQueue.main.async {
                self.tableVw.reloadData({
                    self.tableVw.setContentOffset(CGPoint.zero, animated: true)
                    self.refreshControl.endRefreshing()
                })
            }
            
        } else {
            //===========================
            //         Complete
            //===========================
            self.completeArray = data
            self.currentArray = self.completeArray
            
            DispatchQueue.main.async {
                self.collectionVw.reloadData({
                    self.collectionVw.setContentOffset(CGPoint.zero, animated: true)
                })
            }
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapSegmentVwController(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            //===========================
            //         Pending
            //===========================
            self.isNotReloadFromHistory = false
            self.segmentIndexZeroView()
            
        case 1:
            //===========================
            //         Complete
            //===========================
            self.tableVw.isHidden = true
            self.collectionVw.isHidden = false
            self.isNotReloadFromHistory = true
            if self.completeArray.count > 0 {
                self.currentArray = self.completeArray
                DispatchQueue.main.async {
                    self.collectionVw.reloadData({
                        self.collectionVw.setContentOffset(CGPoint.zero, animated: true)
                    })
                }
            } else {
                self.apiCallForProducts(isPending: false)
            }
            
        default:
            break;
        }
    }
    func segmentIndexZeroView(){
        self.tableVw.isHidden = false
        self.collectionVw.isHidden = true
        
        
        self.errorLbl.isHidden = true
        if self.pendingArray.count > 0 {
            self.currentArray = self.pendingArray
        } else {
            self.apiCallForProducts(isPending: true)
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
    
    @IBAction func unwindFromHistoryDetail(_ sender : UIStoryboardSegue){
        if sender.source is HistoryDetailViewController{
            self.isNotReloadFromHistory = true
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension HistoryViewController:UITableViewDelegate,UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryPendindCell.className, for: indexPath) as! HistoryPendindCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        cell.imageVw.image = #imageLiteral(resourceName: "background_default")
        cell.dateLbl.text = ""
        
        //===========================
        //        SetUp Cell
        //===========================
        
        if !cell.isGradientAdded {
            DispatchQueue.main.async {
                cell.imageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: (cell.imageVw.height/2), width: cell.imageVw.width, height: (cell.imageVw.height/2)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
                cell.isGradientAdded = true
            }
        }
        
        if currentArray.count > indexPath.row {
            let model = self.currentArray[indexPath.row]
            
            cell.imageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default"), contentMode: cell.imageVw.contentMode)
            cell.priceLbl.text = "£ " + "\((model.retailPrice ?? 0.0).clean)"
            cell.totalTicketsLbl.text = "\(model.totalTickets ?? 0)"
            cell.availableTicketsLbl.text = "\(model.availableTickets ?? 0)"
            
            cell.titleLbl.text = model.brand ?? ""
            if cell.titleLbl.text != "" {
                cell.titleLbl.text = (cell.titleLbl.text ?? "") + (" - \(model.productName ?? "")")
            } else {
                cell.titleLbl.text = model.productName ?? ""
            }
            
            if var dates = model.raffleDrawnDate, dates != "" {
                dates = dates.substring(19)
                cell.dateLbl.text = dates.convertToShowFormatDate(dateFormatForInput: "yyyy-MM-dd'T'HH:mm:ss", dateFormatForOutput: "dd MMM yyyy")
            }
            
            cell.tierNameLbl.text = model.tierName ?? ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentArray.count > indexPath.row {
            if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: HistoryDetailViewController.className) as? HistoryDetailViewController {
                productDetailVC.productDetail = currentArray[indexPath.row]
                self.isNotReloadFromHistory = false
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 200
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension HistoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentArray.count == 0 {
            self.errorLbl.isHidden = false
        } else {
            self.errorLbl.isHidden = true
        }
        return currentArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCompleteCell.className, for: indexPath) as! HistoryCompleteCell
        
        cell.imageVw.image = #imageLiteral(resourceName: "background_default")

        //===========================
        //        SetUp Cell
        //===========================
        
        if !cell.isGradientAdded {
            DispatchQueue.main.async {
                cell.imageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: (cell.imageVw.height/2), width: cell.imageVw.width, height: (cell.imageVw.height/2)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
                cell.isGradientAdded = true
            }
        }
        
        if currentArray.count > indexPath.row {
            let model = self.currentArray[indexPath.row]
            
            cell.imageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default") ,contentMode:cell.imageVw.contentMode)
            
            cell.titleLbl.text = model.brand ?? ""
            if cell.titleLbl.text != "" {
                cell.titleLbl.text = (cell.titleLbl.text ?? "") + (" - \(model.productName ?? "")")
            } else {
                cell.titleLbl.text = model.productName ?? ""
            }
            
            switch model.resultStatus ?? "" {
            case "Waiting":
                cell.resultImageVw.image = nil
                
            case "Won":
                cell.resultImageVw.image = #imageLiteral(resourceName: "won")
                
            case "Lose":
                 cell.resultImageVw.image = #imageLiteral(resourceName: "lose")
                
            default:
                cell.titleLbl.text = model.resultStatus ?? ""
                cell.resultImageVw.image = nil
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentArray.count > indexPath.row {
            if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: HistoryDetailViewController.className) as? HistoryDetailViewController {
                productDetailVC.productDetail = currentArray[indexPath.row]
                productDetailVC.isFromHVC = true
                self.isNotReloadFromHistory = true
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width   = self.collectionVw.width/2 - 5
        let hieght  = width + 50
        return CGSize.init(width: width, height: hieght)
    }
}

// MARK: -  API Calling Methods.
extension HistoryViewController {
    
    func apiCallForProducts(isPending:Bool) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId": user.id ?? 0,
                               "Type": isPending ? "Waiting" : "Complete"
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetHistory(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        var datasModel = [ProductModel]()
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            for items in datas {
                                datasModel.append(ProductModel.init(fromDictionary: items))
                            }
                        }
                        self.createData(isPending: isPending, data: datasModel)
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
//                              MARK: -  Class:- UICollectionViewCell.
//=========================================================================================================
//=========================================================================================================

class HistoryCompleteCell: UICollectionViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var resultImageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var isGradientAdded = false
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UITableViewCell.
//=========================================================================================================
//=========================================================================================================

class HistoryPendindCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var totalTicketsLbl: UILabel!
    @IBOutlet weak var availableTicketsLbl: UILabel!
    @IBOutlet weak var tierNameLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var isGradientAdded = false
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
