//
//  HistoryDetailViewController.swift
//  Rafup
//
//  Created by Ashish on 19/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var productTypeLbl: UILabel!
    @IBOutlet weak var RatailPriceLbl: UILabel!
    @IBOutlet weak var totalTicketTitleLbl: UILabel!
    @IBOutlet weak var totalTicketsLbl: UILabel!
    @IBOutlet weak var availableTicketsLbl: UILabel!
    @IBOutlet weak var quizBtn: UIButton!
    @IBOutlet weak var tierNameLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var avialableTicketViewHieght: NSLayoutConstraint!
    @IBOutlet weak var quizButtonHieght: NSLayoutConstraint!
    
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var GenderView: UIView!
    @IBOutlet weak var lblLength: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var legthView: UIView!
    
    // MARK: -  Variable Declaration.
    var productDetail = ProductModel()
    var lastCollectionViewIndex = 0
    let sizeCellSize  = 25
    var ticketID : Int = 0
    var productStatus : String = ""
    var isFromHVC : Bool = false
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (isFromHVC){
            performSegue(withIdentifier: "unwindToHistory", sender: self)
        }
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        self.setNavigation(title: "History Detail")
        self.navigationController?.removeBackButtonTitle()
        
        //Set delegate and datasource of collectionVw
        collectionVw.delegate = self
        collectionVw.dataSource = self
        
        collectionVw.reloadData()
        
        //Increase page congtrol size.
        pageController.transform = CGAffineTransform(scaleX: 2.0, y: 2.0); //set value here
        
        //Set number of pages for button dot indicator.
        self.pageController.numberOfPages = productDetail.images.count
        self.pageController.hidesForSinglePage = true
        self.setUpPageViewController(selectedIndex: 0)
        
        setUpUI()
        
        if isFromHVC{
            ticketID = self.productDetail.ticketId ?? 0
            productStatus = self.productDetail.resultStatus ?? ""
        }
        self.apiCallForHistoryDetail(product: self.productDetail)
        
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
    
    // MARK:- Setup UI Method.
    func setUpUI() {
        self.collectionVw.reloadData()
        self.setUpPageViewController(selectedIndex: 0)
        self.titleLbl.text          = self.productDetail.brand ?? ""
        if self.titleLbl.text != "" {
            self.titleLbl.text      = (self.titleLbl.text ?? "") + (" - \(self.productDetail.productName ?? "")")
        } else {
            self.titleLbl.text      = self.productDetail.productName ?? ""
        }
        
        self.descriptionLbl.text    = self.productDetail.descriptions ?? ""
        self.tierNameLbl.text       = self.productDetail.tierName ?? ""
        self.priceLbl.text = "£ " + "\((self.productDetail.ticketPrice ?? 0.0).clean)"
        self.RatailPriceLbl.text = "£ " + "\((self.productDetail.retailPrice ?? 0.0).clean)"
        self.totalTicketsLbl.text   = "\(self.productDetail.totalTickets ?? 0)"
        self.availableTicketsLbl.text = "\(self.productDetail.availableTickets ?? 0)"
        self.sizeLbl.text           = self.productDetail.size ?? ""
        self.productTypeLbl.text    = self.productDetail.productType ?? ""
        if (self.productDetail.isAnswered ?? false ||  self.productDetail.resultStatus == "Done") {
            self.quizButtonHieght.constant = 0
        }
        if (self.productDetail.productType == ConstantsKey.kTrouser
            || self.productDetail.productType == ConstantsKey.kSkirt
            || self.productDetail.productType == ConstantsKey.kJeans)
        {
            sizeView.isHidden = false
            legthView.isHidden = false
            lblLength.text = self.productDetail.length ?? ""
        }
        else if (self.productDetail.productType == ConstantsKey.kAccessory){
            sizeView.isHidden = true
            legthView.isHidden = true
        }
        else{
            sizeView.isHidden = false
            legthView.isHidden = true
        }
        
        //for gender
        self.lblGender.text = self.productDetail.gender == "Both" ? "Male & Female" : self.productDetail.gender
        GenderView.isHidden = false
        legthView.isHidden = false
        
        
        switch self.productDetail.resultStatus ?? "" {
        case "Waiting":
            self.totalTicketTitleLbl.text = "Total Tickets"
            self.totalTicketsLbl.text     = self.productDetail.resultStatus ?? ""
            self.quizBtn.isHidden = false
            break
        case "Won","Lose":
            self.totalTicketTitleLbl.text = "Result"
            self.totalTicketsLbl.text     = "You \(self.productDetail.resultStatus ?? "")"
            self.avialableTicketViewHieght.constant = 0
            self.quizBtn.isHidden = true
            break
        default:
            break;
        }
        
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapQuizButton(_ sender: UIButton) {
        if let questionVc = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: QuestionsViewController.className) as? QuestionsViewController {
            questionVc.productId = self.productDetail.productId
            questionVc.ticketId = self.productDetail.ticketId
            self.navigationController?.pushViewController(questionVc, animated: true)
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension HistoryDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImagesCell.className, for: indexPath) as! ProductImagesCell
        
        cell.imageVw.image      = #imageLiteral(resourceName: "background_default")
        
        //===========================
        //        SetUp Cell
        //===========================
        
        if productDetail.images.count > indexPath.row {
            let model = productDetail.images[indexPath.row]
            cell.imageVw.setImageWithURL(url: model.image ?? "" , placeholder: #imageLiteral(resourceName: "background_default"), contentMode: cell.imageVw.contentMode)
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

// MARK: -  API Calling Methods.
extension HistoryDetailViewController {
    
    func apiCallForHistoryDetail(product:ProductModel) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId"   : user.id ?? 0,
                               "TicketId" : self.ticketID ,
                               "Type"     : self.productStatus
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForGetHistoryDetail(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [[String:Any]] {
                            if (datas.count>0){
                                self.productDetail = ProductModel.init(fromDictionary: datas[0])
                            }
                        }
                        DispatchQueue.main.async {
                            self.setUpUI()
                        }
                    }
                }
            }
        }
    }
}
