//
//  SettingsViewController.swift
//  Rafup
//
//  Created by Ashish on 25/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {

    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var backgroundVw: GradientView!
    @IBOutlet weak var tableVw: UITableView!
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var pontsLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    var dataArray = ["Profile", "Change password", "Share points","Invite friend", "Contact us", "Privacy policy", "Logout"]
    
    // MARK: -  UIViewController Override Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupInitailView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallForUserProfile()
    }
    
    // MARK: -  Initial View Setup Method.
    func setupInitailView() {
        
        //  Setup Navigation bar.
        self.setNavigation(title: "Settings")
        self.navigationController?.removeBackButtonTitle()
        self.setTopNavigation(for: [.leftMenu])
        
        //  Remove footer View.
        self.tableVw.tableFooterView = UIView()
        
        //Set delegate and datasource of tableVw
        tableVw.delegate = self
        tableVw.dataSource = self
        tableVw.reloadData()
        
        
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
extension SettingsViewController {
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
                        
                        DispatchQueue.main.async {
                            self.userNameLbl.text  = "\(datas["Name"] ?? "")"
                            self.pontsLbl.text = "\(datas["Points"] ?? 0)"
                                self.imageVw.setImageWithURL(url: "\(datas["ProfileImage"] ?? "")", placeholder: AssetsImages.kDefaultUser, contentMode: self.imageVw.contentMode)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource Methods.
extension SettingsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.className, for: indexPath) as! SettingsCell
        
        //Remove selected cell background colour.
        cell.selectionStyle = .none
        
        //===========================
        //        SetUp Cell
        //===========================
        
        if dataArray.count > indexPath.row {
            cell.titleLbl.text = dataArray[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray.count > indexPath.row {
            switch indexPath.row {
            case 0:
                print("Profile")
                DispatchQueue.main.async {
                    if let contactUs = self.storyboard?.instantiateViewController(withIdentifier: ProfileViewController.className) as? ProfileViewController {
                        self.navigationController?.pushViewController(contactUs, animated: true)
                    }
                }
                
            case 1:
                print("Change password")
                DispatchQueue.main.async {
                    if let changePasswordVC = self.storyboard?.instantiateViewController(withIdentifier: ChangePasswordViewController.className) as? ChangePasswordViewController {
                        self.navigationController?.pushViewController(changePasswordVC, animated: true)
                    }
                }
                
            case 2:
                print("Share points")
                DispatchQueue.main.async {
                    if let sharePointsVC = self.storyboard?.instantiateViewController(withIdentifier: PromoCodeViewController.className) as? PromoCodeViewController {
                        self.navigationController?.pushViewController(sharePointsVC, animated: true)
                    }
                }
                
            case 3:
                print("Invite friend")
                DispatchQueue.main.async {
                    if let invite = URL.init(string: Urls.appStoreLink) {
                        self.socialShare(with: ConstantsMessages.kDownloadMessage, image: nil, url: invite)
                    }
                }
                
            case 4:
                print("Contact")
                DispatchQueue.main.async {
                    if let contactUs = self.storyboard?.instantiateViewController(withIdentifier: ContactUsViewController.className) as? ContactUsViewController {
                        self.navigationController?.pushViewController(contactUs, animated: true)
                    }
                }
                
            case 5:
                print("Privacy policy")
                DispatchQueue.main.async {
                    if let privacy = URL.init(string: Urls.privacyAndPolicy) {
                            let svc = SFSafariViewController(url: privacy)
                            self.present(svc, animated: true, completion: nil)
                    }
                }
                
            case 6:
                print("Logout")
                DispatchQueue.main.async {
                    self.presentAlertWith(message: ConstantsMessages.kLogout, oktitle: "Sign Out", okButtonType:.destructive, okaction: {
                        Constants.kAppDelegate.logout()
                    }, notitle: "Cancel", noaction: nil)
                }
                
            default:
                break;
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableVw.estimatedRowHeight = 80
        return UITableViewAutomaticDimension
    }
    
}

//=========================================================================================================
//=========================================================================================================
//                              MARK: -  Class:- UITableViewCell.
//=========================================================================================================
//=========================================================================================================

class SettingsCell: UITableViewCell {
    
    // MARK: -  IBOutlet Declaration.
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // MARK: -  Variable Declaration.
    
    // MARK: -  Cell Initialization Method.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


