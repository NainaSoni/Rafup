//
//  TiersViewController.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class TiersViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var errorLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var lastCollectionViewIndex = 0
    var plansArray = [TiersnModel]()
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "Tiers")
        self.navigationController?.removeBackButtonTitle()
        
        //Set delegate and datasource of collectionVw
        collectionVw.delegate = self
        collectionVw.dataSource = self
        
        collectionVw.reloadData()
        
        //Increase page congtrol size.
        pageController.transform = CGAffineTransform(scaleX: 2.0, y: 2.0); //set value here
        
        //Set number of pages for button dot indicator.
        self.pageController.numberOfPages = plansArray.count
        self.pageController.hidesForSinglePage = true
        self.setUpPageViewController(selectedIndex: 0)
        
        self.apiCallForGetTiers()
        
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
        }
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

// MARK: -  API Calling Methods.
extension TiersViewController {
    
    func apiCallForGetTiers() {
        let parameters = [ String:  Any]()
        Global.showLoadingSpinner()
        ApiManager.apiCallForTiers(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [[String:Any]] {
                        for items in datas {
                            self.plansArray.append(TiersnModel.init(fromDictionary: items))
                        }
                        DispatchQueue.main.async {
                            //Set page control count.
                            self.pageController.numberOfPages = self.plansArray.count
                            self.collectionVw.reloadData()
                            self.setUpPageViewController(selectedIndex: 0)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension TiersViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if plansArray.count == 0 {
            self.errorLbl.isHidden = false
        } else {
            self.errorLbl.isHidden = true
        }
        return plansArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TiersCell.className, for: indexPath) as! TiersCell
        
        cell.tierImageVw.image      = #imageLiteral(resourceName: "bronze")
        cell.pricleLbl.text         = ""
        //cell.discriptionLbl.text    = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
        cell.tierNameLbl.text       = ""
        
        //===========================
        //        SetUp Cell
        //===========================
    
        if plansArray.count > indexPath.row {
            let model = self.plansArray[indexPath.row]
            cell.tierImageVw.setImageWithURL(url: model.tierImage, placeholder: #imageLiteral(resourceName: "bronze"))
            cell.pricleLbl.text = "£ " + "\((model.price ?? 0).clean)"
            cell.tierNameLbl.text = (model.name ?? "") + "Tier"
            
            if(model.name == "Bronze"){
                cell.tierImageVw.image      = #imageLiteral(resourceName: "bronzeM")
            }else if(model.name == "Silver"){
                cell.tierImageVw.image      = #imageLiteral(resourceName: "silver")
            }else if(model.name == "Gold"){
                cell.tierImageVw.image      = #imageLiteral(resourceName: "gold")
            }else if(model.name == "Platinum"){
                cell.tierImageVw.image      = #imageLiteral(resourceName: "platinum")
            }else{
                cell.tierImageVw.image      = #imageLiteral(resourceName: "bronze")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width   = self.collectionVw.width
        let hieght  = self.collectionVw.height
        return CGSize.init(width: width, height: hieght)
    }
    
    //MARK:- ScrollView delegate Method.
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //Get Index of visible cell from colectionsView.
        let visibleCell = scrollView.currentPage - 1
        if lastCollectionViewIndex != visibleCell {
            lastCollectionViewIndex = visibleCell
            self.pageController.currentPage = visibleCell
            self.setUpPageViewController(selectedIndex: visibleCell)
        }
    }
}


//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UICollectionViewCell.
//=========================================================================================================
//=========================================================================================================

class TiersCell: UICollectionViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var tierImageVw: UIImageView!
    @IBOutlet weak var tierNameLbl: UILabel!
    @IBOutlet weak var discriptionLbl: UILabel!
    @IBOutlet weak var pricleLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapViewProductsButton(_ sender: Any) {
        if let tierVC = self.parentViewController as? TiersViewController {
            if let indexPath = tierVC.collectionVw.indexPath(for: self) {
                if let productsVC = tierVC.storyboard?.instantiateViewController(withIdentifier: ProductsViewController.className) as? ProductsViewController {
                    productsVC.tier = tierVC.plansArray[indexPath.row]
                    tierVC.navigationController?.pushViewController(productsVC, animated: true)
                }
            }
        }
    }
    
}
