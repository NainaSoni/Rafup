//
//  SideMenuViewController.swift
//  Underwrite-it
//
//  Created by Ashish on 14/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

// MARK: -  SetUp Side Menu Items.
enum sideMenuItems {
    case home
    case ticketHistory
    case settings
    case consolutionItems
    case comingSoon
    case logout
    
    static let mainMenuItems = [home, ticketHistory, settings, consolutionItems , comingSoon, logout]
    
    var menuProperty: (icon: UIImage, name: String, index:Int) {
        switch self {
        case .home:
            return (#imageLiteral(resourceName: "home"), "Home", 0)
        case .ticketHistory:
            return (#imageLiteral(resourceName: "ticket_history"), "Ticket History", 1)
        case .settings:
            return (#imageLiteral(resourceName: "settings"), "Settings", 2)
        case .consolutionItems:
            return (#imageLiteral(resourceName: "consolation_items"), "Loyalty Points", 3)
        case .comingSoon:
            return (#imageLiteral(resourceName: "coming_soon"), "Coming soon", 4)
        case .logout:
            return (#imageLiteral(resourceName: "logout"), "Logout", 5)
        }
    }
}

class SideMenuViewController: UIViewController {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var userImageVw: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var tableVw: UITableView!
    
    // MARK: -  Variable Declaration.
    var isChangeUserImage = false
    var selectedRow     = 0
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupInitailView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.apiCallForUserProfile), name: NSNotification.Name(rawValue: "userData"), object: nil)
        
    }
    
    @objc func apiCallForUserProfile() {
        if let user = UserProfileModel.getUserLogin() {
            let parameters = [ "Id" : user.id ?? 0
                ] as [String : Any]
            ApiManager.apiCallForGetUserProfile(parameters: parameters) { (responseObject, error) in
                if let responseObjects = responseObject {
                    if let datas = responseObjects["Data"] as? [String:Any] {
                        user.updateUserAndSave(attributes: datas)
                        DispatchQueue.main.async {
                            self.setupInitailView()
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        //Set User Header
        if let user = UserProfileModel.getUserLogin() {
            userNameLbl.text        = user.username ?? "Hi !!!"
            userImageVw.setImageWithURL(url: user.userImage ?? "", placeholder: AssetsImages.kDefaultUser, contentMode: userImageVw.contentMode)
        }
        //Set delegate and datasource of tableview
        tableVw.delegate = self
        tableVw.dataSource = self
        tableVw.tableFooterView = UIView()
        tableVw.reloadData()
    }
    
    // MARK: -  IBAction Methods.
    @IBAction func didTapUserImageChangeButton(_ sender: UIButton) {
        MediaUtilityClass.sharedInstanse().pickImage(message:  "Choose user image", completionHandler: { (img, imageURL, error) in
            if let image = img {
                self.userImageVw.image = image
                //self.isChangeUserImage = true
                self.apiCallForUpdateUserProfile()
            }
        })
    }
    
    // MARK: -  Change front ViewController for side menu Mehod.
    private func pushFrontViewController(viewController:UIViewController) {
        Constants.kAppDelegate.sideMenu?.rootViewController = viewController
        Constants.kAppDelegate.sideMenu?.hideLeftViewAnimated()
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

// MARK: - UITableViewDelegate And UITableViewDataSource Methods.
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuItems.mainMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.className, for: indexPath) as! SideMenuCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        //===========================
        //        SetUp Cell
        //===========================
        let sideMenuItem = sideMenuItems.mainMenuItems[indexPath.row]
        
        cell.titleLbl.text = sideMenuItem.menuProperty.name
        cell.imageVw.image = sideMenuItem.menuProperty.icon
        
        if  self.selectedRow == indexPath.row {
            cell.backgroundColor        = cell.selectedCellColour
            cell.sideVw.backgroundColor = cell.selectedColour
        } else {
            cell.backgroundColor        = cell.unSelectedCellColour
            cell.sideVw.backgroundColor = cell.unSelectedCellColour
        }
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Change front ViewController
        let sideMenuItem = sideMenuItems.mainMenuItems[indexPath.row]
        
        self.selectedRow = indexPath.row
        self.tableVw.reloadData()
        
        switch sideMenuItem {
            
        case .home:
            print("home")
            if let dashboardNav = Storyboard.kMainStoryboard.instantiateViewController(withIdentifier: "sideMenuRootNavigation") as? UINavigationController {
                self.pushFrontViewController(viewController: dashboardNav)
            }
    
        case .ticketHistory:
            print("ticketHistory")
            if let historyNav = Storyboard.kHistoryStoryboard.instantiateViewController(withIdentifier: "historyNav") as? UINavigationController {
                self.pushFrontViewController(viewController: historyNav)
            }
            
        case .settings:
            print("settings")
            if let settingsNav = Storyboard.kHistoryStoryboard.instantiateViewController(withIdentifier: "settingsNav") as? UINavigationController {
                self.pushFrontViewController(viewController: settingsNav)
            }
            
        case .consolutionItems:
            print("consolution Items")
            if let historyNav = Storyboard.kHistoryStoryboard.instantiateViewController(withIdentifier: "consolationNav") as? UINavigationController {
                self.pushFrontViewController(viewController: historyNav)
            }
        case .comingSoon:
            break
        case .logout:
            print("logout")
            DispatchQueue.main.async {
                self.presentAlertWith(message: ConstantsMessages.kLogout, oktitle: "Sign Out", okButtonType:.destructive, okaction: {
                    Constants.kAppDelegate.logout()
                }, notitle: "Cancel", noaction: nil)
            }
        
        }
    }
    
}

// MARK: -  API Calling Methods.
extension SideMenuViewController {
    
    func apiCallForUpdateUserProfile() {
        
        if (self.userImageVw.image == nil) {
            Global.showAlert(withMessage:ValidationError.OfType.errorWithMessage(message: "Please choose image.").description, sender: nil)
            return
        }
        
        Global.showLoadingSpinner()
        let user = UserProfileModel.getUserLogin()
        var parameters = [ "Name"     : user?.username ?? "" ,
                           "Email"    : user?.email ?? "",
                           "Zipcode"  : user?.zipCode ?? "",
                           "Address"  : user?.address ?? "",
                           "Mobile"   : user?.mobileNumber ?? "",
                           "UserId"   : user?.id as Any,
                           ] as [String : Any]
        
        parameters.merge(with: ["IsJoinMaiing"  : user?.isJoiningMail ?? false,
                                "IsEighteenPlus": user?.isEighteenPlus ?? false,
                                "ShoeSize"      : user?.shoeSize ?? "",
                                "TrouserSize"   : user?.touserSize ?? "",
                                "TopSize"       : user?.tShirtSize ?? ""])
        
        parameters.merge(with: ["Images":[["Image":self.userImageVw.image!.base64String(), "Name":"Profile"]]])
        
        
        ApiManager.apiCallForUpdateProfile(parameters: parameters) { (responseObject, error) in
            Global.dismissLoadingSpinner()
            if let responseObjects = responseObject {
                var messages = ConstantsMessages.kSucessfullyRegister
                if let message = responseObjects["ResponseMessage"] as? String {
                    messages = message
                }
            }
        }
    }
    
}
