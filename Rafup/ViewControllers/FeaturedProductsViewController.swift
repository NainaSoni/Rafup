//
//  FeaturedProductsViewController.swift
//  Rafup
//
//  Created by Ashish on 14/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class FeaturedProductsViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var productsArray       = [ProductModel]()
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
        self.setNavigation(title: "Featured Competition")
        self.navigationController?.removeBackButtonTitle()
        self.hideNavigationBarBottomLine()
        
        self.showNavigationBar()
        
        //Set delegate and datasource of collectionVw
        tableVw.delegate = self
        tableVw.dataSource = self
        
        tableVw.reloadData()
        
        self.apiCallForFeaturedProducts(type: .featured)
        
        //pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action:#selector(action), for: UIControl.Event.valueChanged)
        tableVw.addSubview(refreshControl)
        
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
    }
    @objc func action(){
        self.apiCallForFeaturedProducts(type: .featured)
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

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension FeaturedProductsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productsArray.count == 0 {
            self.errorLbl.isHidden = false
        } else {
            self.errorLbl.isHidden = true
        }
        return productsArray.count
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
        
        if productsArray.count > indexPath.row {
            let model = self.productsArray[indexPath.row]
            
            cell.imageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default"))
            cell.priceLbl.text = "£ " + "\(model.retailPrice ?? 0.0)"
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
        if productsArray.count > indexPath.row {
            if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: ProductDetailViewController.className) as? ProductDetailViewController {
                productDetailVC.productDetail = productsArray[indexPath.row]
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

// MARK: -  API Calling Methods.
extension FeaturedProductsViewController {
    
    func apiCallForFeaturedProducts(type:RaffleType) {
        let parameters = [ "TierId":  "",
                           "IsFeatured" : "1",
                           "IsEighteenPlus": "0"
            ] as [String : Any]
        Global.showLoadingSpinner()
        ApiManager.apiCallForGetFeaturedProducts(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    self.productsArray = []
                    if let datas = responseObjects["Data"] as? [[String:Any]] {
                        for items in datas {
                            self.productsArray.append(ProductModel.init(fromDictionary: items))
                        }
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.tableVw.reloadData()
                        }
                    }
                }
            }
        }
    }
}
