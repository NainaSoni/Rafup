//
//  HomeViewController.swift
//  Rafup
//
//  Created by Ashish on 04/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var pageControllerBottom: UIPageControl!
    @IBOutlet weak var collectionVwBottom: UICollectionView!
    @IBOutlet weak var featuredCollectionViewCellHeight: NSLayoutConstraint!
    
    // MARK: -  Variable Declaration.
    var bestFit:  BestFitModel?
    var bestShoe: BestFitModel?
    var featured: ProductModel?
    
    var featuredArray       = [ProductModel]()
    var bottomArray       = [BestFitModel]()
    
    var lastCollectionViewIndex = 0
    var lastCollectionViewBottomIndex = 0

    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitailView()
        apiCallForUserProfile()
        DispatchQueue.main.async {
            self.collectionVw.reloadData()
            self.collectionVwBottom.reloadData()
        }
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Home")
        self.setTopNavigation(for: [.leftMenu])
        
        
        collectionVw.delegate = self
        collectionVw.dataSource = self
        collectionVw.reloadData()
        
        collectionVwBottom.delegate = self
        collectionVwBottom.dataSource = self
        collectionVwBottom.reloadData()
        
        self.apiCallForBestFit()
        
        //Set number of pages for button dot indicator.
        
        self.pageController.hidesForSinglePage = true
        self.pageControllerBottom.hidesForSinglePage = true
        self.setUpPageViewController(selectedIndex: 0)
        self.apiCallForProducts()
        
        featuredCollectionViewCellHeight.constant = (self.view.bounds.height / 2) - 55
    }
    // MARK: -  Set PageViewController Dots.
    func setUpPageViewController(selectedIndex:Int) {
        var index = 0
        for view in self.pageController.subviews {
            if selectedIndex != index {
                view.layer.borderWidth = 1.0
                view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                view.layer.borderWidth = 0.0
            }
            index = index + 1
        }
        
        
        for view in self.pageControllerBottom.subviews {
            if selectedIndex != index {
                view.layer.borderWidth = 1.0
                view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            } else {
                view.layer.borderWidth = 0.0
            }
            index = index + 1
        }
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapTiersButton(_ sender: UIButton) {
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
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionVwBottom){
            if (bottomArray.count == 0){
                return 1
            }else{
                return self.bottomArray.count
            }
            
        }else{
            if (featuredArray.count > 5){
                return 5
            }else if (featuredArray.count == 0){
                return 1
            }else{
                return featuredArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if (collectionView == collectionVw){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.className, for: indexPath) as! HomeCell
            
            //Remove selected cell background colour.
            //cell.selectionStyle = .none
            
            //===========================
            //        SetUp Cell
            //===========================
            
            cell.contestImageVw.image =  #imageLiteral(resourceName: "RAFUP_PHOTO")
            cell.ticketCountLbl.text = " "
            
            
            //cell.titleLbl.text = "Featured Raffles"
            cell.featureImageVw.isHidden = false
            cell.priceLbl.isHidden = false
            cell.ticketImageVw.isHidden = false
            cell.ticketTitleLbl.isHidden = false
            cell.ticketCountLbl.isHidden = false
            
            cell.titleLbl.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.1477418664)
            
            if !cell.isGradientAdded {
                DispatchQueue.main.async {
                    cell.contestImageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: (cell.contestImageVw.height/2), width: cell.contestImageVw.width, height: (cell.contestImageVw.height/2)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
                    cell.isGradientAdded = true
                }
            }
            
            //=======================
            //       Featured
            //=======================
            
            if featuredArray.count > indexPath.row {
                let model = self.featuredArray[indexPath.row]
                cell.contestImageVw.setImageWithURL(url: model.images.first?.image ?? "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: cell.contestImageVw.contentMode)
                cell.priceLbl.text = "£ " + "\(model.retailPrice ?? 0.0)"
                cell.ticketCountLbl.text = "\(model.availableTickets ?? 0)"
                cell.titleLbl.text = model.productName
            }else{
                cell.contestImageVw.setImageWithURL(url: "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: cell.contestImageVw.contentMode)
                cell.priceLbl.text = "£ " + "0.0"
                cell.ticketCountLbl.text = "0"
                cell.titleLbl.text = ""
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomBottomCell.className, for: indexPath) as! HomBottomCell
            
            
            //===========================
            //        SetUp Cell
            //===========================
            
            cell.contestImageVw.image =  #imageLiteral(resourceName: "parallax")
            cell.titleLbl.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.1477418664)
            
            if !cell.isGradientAdded {
                DispatchQueue.main.async {
                    cell.contestImageVw.setBottomUpGradientLayer(frame: CGRect(x: 0, y: (cell.contestImageVw.height/2), width: cell.contestImageVw.width, height: (cell.contestImageVw.height/2)), colors: [.clear, #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8967519263)])
                    cell.isGradientAdded = true
                }
            }
            
            if bottomArray.count > indexPath.row {
                let model = self.bottomArray[indexPath.row]
                cell.contestImageVw.setImageWithURL(url: model.displayUrl ?? "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: cell.contestImageVw.contentMode)
                
                if ((model.type) == .bestFit){
                    cell.titleLbl.text = "Best fit of the week"
                }else{
                    cell.titleLbl.text =  "Best shoe of the week"
                }
            }else{
                cell.contestImageVw.setImageWithURL(url:  "", placeholder: #imageLiteral(resourceName: "background_default"),  contentMode: cell.contestImageVw.contentMode)
                cell.titleLbl.text = ""
                
            }
            
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == collectionVw){
            //============================
            //    Featured Products
            //============================
            if let featuredVC = self.storyboard?.instantiateViewController(withIdentifier: FeaturedProductsViewController.className) as? FeaturedProductsViewController {
                self.navigationController?.pushViewController(featuredVC, animated: true)
            }
        }else{
            let model = self.bottomArray[indexPath.row]
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == collectionVw){
            let width   = self.collectionVw.width
            let hieght  = self.collectionVw.height
            return CGSize.init(width: width, height: hieght)
        }else{
            let width   = self.collectionVwBottom.width
            let hieght  = self.collectionVwBottom.height
            return CGSize.init(width: width, height: hieght)
        }
    }
    
    
    //MARK:- ScrollView delegate Method.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //Get Index of visible cell from colectionsView.
        guard let col = scrollView as? UICollectionView else{
            return
        }
        if (col == collectionVw){
            let visibleCell = scrollView.currentPage - 1
            if lastCollectionViewIndex != visibleCell {
                lastCollectionViewIndex = visibleCell
                self.pageController.currentPage = visibleCell
                self.setUpPageViewController(selectedIndex: visibleCell)
            }
        }else{
            let visibleCell = scrollView.currentPage - 1
            if lastCollectionViewBottomIndex != visibleCell {
                lastCollectionViewBottomIndex = visibleCell
                self.pageControllerBottom.currentPage = visibleCell
                self.setUpPageViewController(selectedIndex: visibleCell)
            }
        }
        
    }
    
}

// MARK: -  UIScrollViewDelegate Methods.
extension HomeViewController: UIScrollViewDelegate {
}

// MARK: -  API Calling Methods.
extension HomeViewController {
    
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
                    var datasModel = [ProductModel]()
                    if let datas = responseObjects["Data"] as? [[String:Any]] {
                        for items in datas {
                            datasModel.append(ProductModel.init(fromDictionary: items))
                        }
                    }
                    self.featuredArray = datasModel
                    
                    DispatchQueue.main.async {
                        self.collectionVw.reloadData()
                        if (self.featuredArray.count > 5){
                            self.pageController.numberOfPages = 5
                        }else{
                            self.pageController.numberOfPages = self.featuredArray.count
                        }
                    }
                }
            }
        }
    }
    
    func apiCallForBestFit() {
        let parameters = [String:Any]()
         Global.showLoadingSpinner()
        ApiManager.apiCallForGetBestFit(parameters: parameters) { (responseObject, error) in
             Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [AnyObject] {
                        var datasModel = [BestFitModel]()
                        for item in datas {
                            if  let dict =  item as? [String: Any]  {
                                datasModel.append(BestFitModel.init(fromDictionary: dict))
                            }
                            self.bottomArray = datasModel
                        }
                        DispatchQueue.main.async {
                            self.collectionVwBottom.reloadData()
                            self.pageControllerBottom.numberOfPages = self.bottomArray.count
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
                Global.showLoadingSpinner()
                ApiManager.apiCallForGetUserProfile(parameters: parameters) { (responseObject, error) in
                    Global.dismissLoadingSpinner()
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [String:Any] {
                            user.updateUserAndSave(attributes: datas)
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

class HomeCell: UICollectionViewCell {
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var contestImageVw: UIImageView!
    @IBOutlet weak var featureImageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var ticketTitleLbl: UILabel!
    @IBOutlet weak var ticketCountLbl: UILabel!
    @IBOutlet weak var ticketImageVw: UIImageView!
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

class HomBottomCell: UICollectionViewCell {
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var contestImageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
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


