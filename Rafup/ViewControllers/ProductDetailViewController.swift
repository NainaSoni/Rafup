//
//  ProductDetailViewController.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
//import CSPieChart

class ProductDetailViewController: UIViewController {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var collectionVw: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var RetailPriceLbl: UILabel!
    
    @IBOutlet weak var totalTicketsLbl: UILabel!
    @IBOutlet weak var availableTicketsLbl: UILabel!
    @IBOutlet weak var probabilityTxtFld: CustomTextField!
    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var tierNameLbl: UILabel!
    @IBOutlet weak var sizeLbl: UILabel!
    @IBOutlet weak var paiChartVw: CSPieChart!
    @IBOutlet weak var txtSize: CustomTextFieldAnimated!
    
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var txtLength: CustomTextFieldAnimated!
    @IBOutlet weak var productTypeLbl: UILabel!
    
    @IBOutlet weak var HeightForSize: NSLayoutConstraint!
    @IBOutlet weak var HeightForProduct: NSLayoutConstraint!
    
    @IBOutlet weak var heightForLength: NSLayoutConstraint!
    
    @IBOutlet weak var viewSize: UIView!
    @IBOutlet weak var viewLength: UIView!
    @IBOutlet weak var viewGender: UIView!
    
    // MARK: -  Variable Declaration.
    var productDetail = ProductModel()
    var tier          = TiersnModel()
    var lastCollectionViewIndex = 0
    var wininngProb             = 0.0
    var sold                    = 0.0
    var remaining               = 0.0
    let sizeCellSize  = 25
    var productID = 0
    var isFromNotification : Bool = false
    var dataList       = [CSPieChartData]()
    var dataListForColor       = [CSPieChartData]()
    var colorList: [UIColor] = [
        #colorLiteral(red: 0.8980392157, green: 0.7490196078, blue: 0.06274509804, alpha: 1),
        #colorLiteral(red: 0.8470588235, green: 0.2745098039, blue: 0.3294117647, alpha: 1),
        #colorLiteral(red: 0, green: 0.6196078431, blue: 0.8862745098, alpha: 1)
    ]
    var colorList1: [UIColor] = [
        #colorLiteral(red: 0.8980392157, green: 0.7490196078, blue: 0.06274509804, alpha: 1)
    ]
    var colorList2: [UIColor] = [
        #colorLiteral(red: 0.8980392157, green: 0.7490196078, blue: 0.06274509804, alpha: 1),
        #colorLiteral(red: 0.8470588235, green: 0.2745098039, blue: 0.3294117647, alpha: 1)
    ]
    
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInitailView()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //Setup Navigation bar.
        //self.setNavigation(title: "Product Detail")
        
        self.setNavigation(title: isFromNotification ? "Product Detail" :  productDetail.productName)
        self.navigationController?.removeBackButtonTitle()
        
        //Set delegate and datasource of collectionVw
        collectionVw.delegate = self
        collectionVw.dataSource = self
        
        collectionVw.reloadData()
        
        probabilityTxtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        //Increase page congtrol size.
        pageController.transform = CGAffineTransform(scaleX: 2.0, y: 2.0); //set value here
        
        //Set number of pages for button dot indicator.
        
        self.pageController.numberOfPages = isFromNotification ? 0 :  productDetail.images.count
        self.pageController.hidesForSinglePage = true
        self.setUpPageViewController(selectedIndex: 0)
        
        paiChartVw.dataSource = self
        paiChartVw.delegate = self
        
        paiChartVw.pieChartRadiusRate = (UIScreen.main.bounds.width/1000) - 0.02 //0.65
        paiChartVw.pieChartLineLength = 10
        paiChartVw.seletingAnimationType = .none
        
        paiChartVw.show(animated: true)
        
        if (isFromNotification == false){
            setUpUI()
        }
        
        self.apiCallForProductsDetail(product:self.productDetail)
        
        DispatchQueue.main.async {
            self.view.setGradient(colours: [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) , #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)])
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
        self.RetailPriceLbl.text = "£ " + "\((self.productDetail.retailPrice ?? 0.0).clean)"
        self.totalTicketsLbl.text   = "\(self.productDetail.totalTickets ?? 0)"
        self.availableTicketsLbl.text = "\(self.productDetail.availableTickets ?? 0)"
        self.sizeLbl.text           = self.productDetail.size ?? ""
        self.productTypeLbl.text    = self.productDetail.productType ?? ""
        
        //for gender
        self.genderLbl.text = self.productDetail.gender == "Both" ? "Male & Female" : self.productDetail.gender
        viewGender.isHidden = false
        
        self.pageController.numberOfPages = productDetail.images.count
        self.pageController.hidesForSinglePage = true
        self.setUpPageViewController(selectedIndex: 0)
        
        
        if ((self.productDetail.productType != ConstantsKey.kTrouser) && (self.productDetail.productType != ConstantsKey.kSkirt) && (self.productDetail.productType != ConstantsKey.kJeans && (self.productDetail.productType != ConstantsKey.kAccessory))){
            heightForLength.constant = 0
            HeightForProduct.constant = 0
            viewLength.isHidden = true
            
        }else if (self.productDetail.productType == ConstantsKey.kAccessory){
            HeightForSize.constant = 0
            heightForLength.constant = 0
            HeightForProduct.constant = 0
            viewLength.isHidden = true
            viewSize.isHidden = true
        }
        else{
            heightForLength.constant = HeightForSize.constant
            HeightForProduct.constant = HeightForSize.constant
            HeightForSize.constant = HeightForSize.constant
            viewLength.isHidden = false
            viewSize.isHidden = false
        }
        
        if (self.productDetail.ticketPrice == 0){
            self.purchaseBtn.setTitle("Participate", for: .normal)
        }else{
            self.purchaseBtn.setTitle("Purchase Ticket (£ \((self.productDetail.ticketPrice ?? 0.0).clean))", for: .normal)
        }
        
        
        self.calculateProbabity(total:self.productDetail.totalTickets ?? 0, available:self.productDetail.availableTickets ?? 0, buy:0)
       
    }
    
    // MARK:- Calculate Probability Method.
    func calculateProbabity(total:Int, available:Int, buy:Int) {
        
        let win = Double(buy*100)/Double(total)
        let soldV = Double((total - available)*100)/Double(total)
        let remain = Double((available - buy)*100)/Double(total)
        self.wininngProb = Double(win)
        self.sold        = Double(soldV)
        self.remaining   = Double(remain)
        
        dataListForColor = []
        dataList = [
            CSPieChartData(key: "Winning", value: wininngProb),
            CSPieChartData(key: "Sold", value: sold),
            CSPieChartData(key: "Remaining", value: remaining)
        ]
        
        if (self.wininngProb > 0.00){
            dataListForColor.append(CSPieChartData(key: "Winning", value: wininngProb))
        }
        if (self.sold > 0.00){
             dataListForColor.append(CSPieChartData(key: "Sold", value: sold))
        }
        if (self.remaining > 0.00){
            dataListForColor.append(CSPieChartData(key: "Remaining", value: remaining))
        }
        
        
        self.paiChartVw.reloadPieChart()
        
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
    @IBAction func didTapPurchaseButton(_ sender: UIButton) {
    
        //==============================================
        if (UserProfileModel.getUserLogin() != nil) {
            
            if (self.productDetail.availableTickets == 0 || self.productDetail.resultStatus == "Done"){
                DispatchQueue.main.async {
                    self.presentAlertWith(message: ConstantsMessages.kAvailableTicketError, oktitle: "Ok", okaction: {
                    })
                }
            }
            else if (txtSize.text == ""){
                if(self.productDetail.productType == ConstantsKey.kAccessory){
                    goToPurchase()
                }else{
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: ConstantsMessages.kSizeCheck, oktitle: "Ok", okaction: {
                        })
                    }
                }
            }else if (self.productDetail.productType == ConstantsKey.kTrouser || self.productDetail.productType == ConstantsKey.kSkirt || self.productDetail.productType == ConstantsKey.kJeans){
                if (self.txtLength.text == ""){
                    DispatchQueue.main.async {
                        self.presentAlertWith(message: ConstantsMessages.kLengthCheck, oktitle: "Ok", okaction: {
                        })
                    }
                }else{
                    goToPurchase()
                }
            }
            else{
                goToPurchase()
            }
        }
        else{
            DispatchQueue.main.async {
                self.presentAlertWith(message: ConstantsMessages.kParticipateError, oktitle: "Ok", okaction: {
                    self.navigationController?.popToRootViewController(animated: true)
                }, notitle: "Cancel", noaction: nil)
            }
        }
    }
    
    func goToPurchase(){
        if self.productDetail.isEighteenPlus ?? false == true {
            if let user = UserProfileModel.getUserLogin(), user.isEighteenVerified {
                
                if (self.productDetail.ticketPrice == 0){
                    apiCallForPaticipate(product: self.productDetail)
                }else{
                    goToPaymentScreen()
                }
            } else {
                self.presentAlertWith(message: ConstantsMessages.kEighteenError)
            }
        } else {
            if (self.productDetail.ticketPrice == 0){
                apiCallForPaticipate(product: self.productDetail)
            }else{
                goToPaymentScreen()
            }
        }
    }
    func goToPaymentScreen()  {
        if let paymentVC = self.storyboard?.instantiateViewController(withIdentifier: PaymentViewController.className) as? PaymentViewController {
            paymentVC.product = self.productDetail
            paymentVC.productSize = self.txtSize.text ?? ""
            paymentVC.productLength = self.txtLength.text ?? ""
            paymentVC.Gender = self.productDetail.gender ?? ""
            self.navigationController?.pushViewController(paymentVC, animated: true)
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

// MARK:- TextFiled Value Change Methods.
extension ProductDetailViewController {
    // MARK:- TextFiled Value Change Methods.
    @objc func textFieldDidChange(_ textField: CustomTextField) {
        if textField.text != ""  {
            if Int(textField.text ?? "0") ?? 0 <= self.productDetail.availableTickets ?? 0 {
                self.calculateProbabity(total:self.productDetail.totalTickets ?? 0, available:self.productDetail.availableTickets ?? 0, buy:Int(textField.text ?? "0") ?? 0)
            } else {
                textField.text = ""
                self.presentAlertWith(message: ConstantsMessages.kProbabilityError)
            }
        } else {
            self.calculateProbabity(total:self.productDetail.totalTickets ?? 0, available:self.productDetail.availableTickets ?? 0, buy:0)
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout Methods
extension ProductDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
            //cell.imageVw.image = UIImage.gifImageWithURL(model.image ?? "")
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

//MARK:- CSPieChartDataSource Method.
extension ProductDetailViewController :CSPieChartDataSource {
    func pieChart(_ pieChart: CSPieChart, dataForComponentAt index: Int) -> CSPieChartData {
        return dataList[index]
    }
    
    func pieChart(_ pieChart: CSPieChart, colorForComponentAt index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfComponentData() -> Int {
        return dataList.count
        //return dataListForColor.count
    }
    
    func numberOfComponentColors() -> Int {
        return colorList.count
        
        //return dataListForColor.count
    }
    
    func numberOfLineColors() -> Int {
        return colorList.count
        //return dataListForColor.count
    }
    
    func pieChart(_ pieChart: CSPieChart, lineColorForComponentAt index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfComponentSubViews() -> Int {
        return dataList.count
    }
    func pieChart(_ pieChart: CSPieChart, viewForComponentAt index: Int) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        label.font = label.font.withSize(12)
        label.numberOfLines = 0
        switch index {
        case 0:
            let value = String(format: "%.2f", self.wininngProb)
            if (value == "0.00"){
                label.isHidden = true
            }else{
                label.isHidden = false
                label.text = value + "% Winning"
            }
            label.textColor = colorList[index]
        case 1:
            let value = String(format: "%.2f", self.sold)
            if (value == "0.00"){
                label.isHidden = true
            }else{
                label.isHidden = false
                label.text = value + "% Sold"
            }
            label.textColor = colorList[index]
        case 2:
            let value = String(format: "%.2f", self.remaining)
            if (value == "0.00"){
                label.isHidden = true
            }else{
                label.isHidden = false
                label.text = value + "% Remaining"
            }
            label.textColor = colorList[index]
        default:
            break;
        }
        return label
    }
   
}

//MARK:- CSPieChartDelegate Method.
extension ProductDetailViewController: CSPieChartDelegate {
    func didSelectedPieChartComponent(at index: Int) {
    }
}

// MARK: -  API Calling Methods.
extension ProductDetailViewController {
    
    func apiCallForProductsDetail(product:ProductModel) {
        let parameters = [ "ProductId" : isFromNotification ? productID : product.productId ?? 0
            ] as [String : Any]
        Global.showLoadingSpinner()
        ApiManager.apiCallForGetProductDetail(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if (error == nil) {
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [String:Any] {
                        self.productDetail = ProductModel.init(fromDictionary: datas)
                    }
                    let getSize = self.productDetail.size
                    let arrSize = getSize?.components(separatedBy: ",")
                    
                    let getLength = self.productDetail.length
                    let arrLength = getLength?.components(separatedBy: ",")
                    
                    DispatchQueue.main.async {
                        self.txtSize.setRightViewImage(#imageLiteral(resourceName: "drop"))
                        self.txtSize.inputPicker = true
                        self.txtSize.pickerArray = arrSize!
                        
                        self.txtLength.setRightViewImage(#imageLiteral(resourceName: "drop"))
                        self.txtLength.inputPicker = true
                        self.txtLength.pickerArray = arrLength!
                        //productDetail.images
                        self.setUpUI()
                    }
                }
            }
        }
    }
    // register participant api
    func apiCallForPaticipate(product:ProductModel) {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "UserId" : (user.id ?? 0) as Any,
                               "ProductId" : (product.productId ?? 0) as Any,
                               "SelectedSize" : (self.txtSize.text ?? "") as Any,
                               "SelectedLength" : (txtLength.text ?? "") as Any,
                               "Gender" : (product.gender ?? "") as Any,
                               "Price" : 0 as Any
                ] as [String : Any]
            Global.showLoadingSpinner()
            ApiManager.apiCallForBuyTicket(parameters: parameters) { (responseObject, error) in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    if let responseObjects = responseObject {
                        if let datas = responseObjects["Data"] as? [ String:Any] {
                            
                            DispatchQueue.main.async {
                                self.presentAlertWith(message: responseObjects["ResponseMessage"] as! String, oktitle: "Play quiz", okaction: {
                                    if let questionVc = self.storyboard?.instantiateViewController(withIdentifier: QuestionsViewController.className) as? QuestionsViewController {
                                        questionVc.productId = product.productId
                                        questionVc.ticketId = datas["TicketId"] as! Int
                                        self.navigationController?.pushViewController(questionVc, animated: true)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.presentAlertWith(message: ConstantsMessages.kParticipateError, oktitle: "Ok", okaction: {
                    self.navigationController?.popToRootViewController(animated: true)
                }, notitle: "Cancel", noaction: nil)
            }
        }
    }
}

//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UICollectionViewCell.
//=========================================================================================================
//=========================================================================================================

class ProductImagesCell: UICollectionViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    
    
    // MARK: -  Variable Declaration.
    
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
