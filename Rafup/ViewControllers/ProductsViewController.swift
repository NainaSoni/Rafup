//
//  ProductsViewController.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

enum RaffleType:String {
    case all           = "All"
    case eighteenPlus  = "18+"
    case featured      = "featured"
}

class ProductsViewController: UIViewController {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var segmentVw: UISegmentedControl!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var currentArray        = [ProductModel]()
    var productsArray       = [ProductModel]()
    var eighteenPlusArray   = [ProductModel]()
    var featuredArray       = [ProductModel]()
    var tier                = TiersnModel()
    var refreshControl = UIRefreshControl()
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Competition")
        self.navigationController?.removeBackButtonTitle()
        self.hideNavigationBarBottomLine()
        
        let font = UIFont.boldSystemFont(ofSize: 18)
        
        //SegmentController selected title text color
        self.segmentVw.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: font], for: UIControlState.selected)
        
        //SegmentController default title text color
        self.segmentVw.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: font], for: UIControlState.normal)
    
        
        //Set delegate and datasource of collectionVw
        tableVw.delegate = self
        tableVw.dataSource = self
        
        tableVw.reloadData()
        
        self.apiCallForProducts(type: .all)
        
        //pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action:#selector(action), for: UIControl.Event.valueChanged)
        tableVw.addSubview(refreshControl)
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
    }
    @objc func action(){
        switch segmentVw.selectedSegmentIndex {
        case 0:
            //===========================
            //           ALL
            //===========================
            self.apiCallForProducts(type: .all)
        case 1:
            //===========================
            //           18+
            //===========================
            self.apiCallForProducts(type: .eighteenPlus)
        case 2:
            //===========================
            //          Featured
            //===========================
            self.apiCallForProducts(type: .featured)
        default:
            break;
        }
        
    }
    
    // MARK: -  Model Creation Methods.
    func createData(type:RaffleType, data:[ProductModel]) {
        
        switch type {
        case .all:
            self.productsArray = data
            self.currentArray = self.productsArray
            
        case .eighteenPlus:
            self.eighteenPlusArray = data
            self.currentArray = self.eighteenPlusArray
            
        case .featured:
            self.featuredArray = data
            self.currentArray = self.featuredArray
        }
        
        DispatchQueue.main.async {
            self.tableVw.reloadData({
                self.tableVw.setContentOffset(CGPoint.zero, animated: true)
            })
        }
    }

    // MARK: -  IBAction Methods.
    @IBAction func didTapSegmentVwController(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            //===========================
            //           ALL
            //===========================
            if self.productsArray.count > 0 {
                self.currentArray = self.productsArray
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.tableVw.reloadData({
                            self.tableVw.setContentOffset(CGPoint.zero, animated: true)
                        })
                    }
                }
            } else {
                self.apiCallForProducts(type: .all)
            }
            
        case 1:
            //===========================
            //           18+
            //===========================
            if self.eighteenPlusArray.count > 0 {
                self.currentArray = self.eighteenPlusArray
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.tableVw.reloadData({
                            self.tableVw.setContentOffset(CGPoint.zero, animated: true)
                        })
                    }
                }
            } else {
                self.apiCallForProducts(type: .eighteenPlus)
            }
            
        case 2:
            //===========================
            //          Featured
            //===========================
            if self.featuredArray.count > 0 {
                self.currentArray = self.featuredArray
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self.tableVw.reloadData({
                            self.tableVw.setContentOffset(CGPoint.zero, animated: true)
                        })
                    }
                }
            } else {
                self.apiCallForProducts(type: .featured)
            }
            
        default:
            break;
        }
    }
    
    // MARK: -  Get Offset Methods.
    func setCellImageOffset(_ cell: ProductCell, indexPath: IndexPath) {
        let cellFrame = self.tableVw.rectForRow(at: indexPath)
        let cellFrameInTable = self.tableVw.convert(cellFrame, to:self.tableVw.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = self.tableVw.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        cell.setBackgroundOffset(cellOffsetFactor)
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
extension ProductsViewController:UITableViewDelegate,UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.className, for: indexPath) as! ProductCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        DispatchQueue.main.async {
            cell.backgroundVw.setGradient(colours: [#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)])
        }
        
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if currentArray.count > indexPath.row {
            if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as? ProductDetailViewController {
                productDetailVC.productDetail = currentArray[indexPath.row]
                productDetailVC.tier = self.tier
                self.navigationController?.pushViewController(productDetailVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageCell = cell as? ProductCell {
            self.setCellImageOffset(imageCell, indexPath: indexPath)
        }
    }
    
}

// MARK: -  UIScrollViewDelegate Methods.
extension ProductsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == self.tableVw) {
            if let visibileIndexes = self.tableVw.indexPathsForVisibleRows {
                for indexPath in visibileIndexes {
                    if let cell = self.tableVw.cellForRow(at: indexPath) as? ProductCell {
                        self.setCellImageOffset(cell, indexPath: indexPath)
                    }
                }
            }
        }
    }
}
        

// MARK: -  API Calling Methods.
extension ProductsViewController {
    
    func apiCallForProducts(type:RaffleType) {
        var parameters = [ "TierId": self.tier.tierId ?? 0
            ] as [String : Any]
        switch type {
        case .all:
            parameters.merge(with: [ "IsFeatured" : "0",
                                     "IsEighteenPlus": "0"])
            
        case .eighteenPlus:
            parameters.merge(with: [ "IsFeatured" : "0",
                                     "IsEighteenPlus": "1"])
            
        case .featured:
            parameters.merge(with: [ "IsFeatured" : "1",
                                     "IsEighteenPlus": "0"])
            
        }
        Global.showLoadingSpinner()
        ApiManager.apiCallForGetProductsWithTiers(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    var datasModel = [ProductModel]()
                    if let datas = responseObjects["Data"] as? [[String:Any]] {
                        for items in datas {
                            datasModel.append(ProductModel.init(fromDictionary: items))
                        }
                    }
                    self.createData(type: type, data: datasModel)
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
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

class ProductCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var totalTicketsLbl: UILabel!
    @IBOutlet weak var availableTicketsLbl: UILabel!
    @IBOutlet weak var imgBackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBackBottomConstraint: NSLayoutConstraint!
    
    // MARK: -  Variable Declaration.
    var isGradientAdded = false
    let imageParallaxFactor: CGFloat = 40
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!
    let yOffsetSpeed: CGFloat = 150.0
    let xOffsetSpeed: CGFloat = 100.0
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgBackBottomConstraint.constant -= 2 * imageParallaxFactor
        self.imgBackTopInitial = self.imgBackTopConstraint.constant
        self.imgBackBottomInitial = self.imgBackBottomConstraint.constant
        
    }
    
    func setBackgroundOffset(_ offset:CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1-boundOffset)*2*imageParallaxFactor
        self.imgBackTopConstraint.constant = self.imgBackTopInitial - pixelOffset
        self.imgBackBottomConstraint.constant = self.imgBackBottomInitial + pixelOffset
    }
    
}
