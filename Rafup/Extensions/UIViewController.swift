//
//  UIViewController.swift
//  Fodder
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.

import UIKit
import MessageUI
import MobileCoreServices
import AVFoundation
import Photos
import AVKit

extension UIViewController {
    
    /***********************************************************************************************/
    //MARK:- Check if ViewController is onscreen and not hidden.
    /***********************************************************************************************/
    public var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return self.isViewLoaded && view.window != nil
    }
    
    func presentAlertWith(message:String) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0
        {
            let alert=UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWith(message:String,oktitle:String,okaction:@escaping (()->Void)) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0 {
            let alert=UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: oktitle, style: .default) { (action) in
                okaction()
            }
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func presentAlertWith(message:String,oktitle:String, okButtonType:UIAlertActionStyle = .default,okaction:@escaping (()->Void),notitle:String,noButtonType:UIAlertActionStyle = .default,noaction:(()->Void)?) {
        let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
        if systemVersion.floatValue >= 8.0 {
            let alert=UIAlertController(title: Constants.kAppDisplayName, message: message, preferredStyle: .alert)
            
            let ok=UIAlertAction(title: oktitle, style: okButtonType) { (action) in
                okaction()
            }
            
            let no=UIAlertAction(title: notitle, style: noButtonType) { (action) in
                noaction?()
            }
            alert.addAction(ok)
            alert.addAction(no)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //  MARK:- Helper method to display an alert on any UIViewController subclass. Uses UIAlertController to show an alert
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message/body of the alert
    ///   - buttonTitles: (Optional)list of button titles for the alert. Default button i.e "OK" will be shown if this paramter is nil
    ///   - highlightedButtonIndex: (Optional) index of the button from buttonTitles that should be highlighted. If this parameter is nil no button will be highlighted
    ///   - completion: (Optional) completion block to be invoked when any one of the buttons is tapped. It passes the index of the tapped button as an argument
    /// - Returns: UIAlertController object (discardable).
    @discardableResult public func showAlertWithHandler(title: String?, message: String?, buttonTitles: [String]? = nil, highlightedButtonIndex: Int? = nil, completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            // Check which button to highlight
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    //  MARK:- Load UIViewController from Storyboard
    ///
    /// - Parameters: Storyborad reference
    static func loadStoryboardFrom(storybord:UIStoryboard) -> UIViewController? {
        return storybord.instantiateViewController(withIdentifier: self.className)
    }
    
    static func loadStoryboard<T: UIViewController>(storyboard:UIStoryboard, of viewcontroller:T.Type) -> T? {
        return storyboard.instantiateViewController(withIdentifier: viewcontroller.className) as? T
    }
    
    //  MARK:- Open device settings for app permissions.
    ///
    ///
    func openSettingApp() {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                // Fallback on earlier versions
                let success = UIApplication.shared.openURL(settingsUrl)
                print("Open \(settingsUrl): \(success)")
            }
        }
        
    }
    
}

private enum ActionType: Int {
    case popViewController
    case popToRootViewController
    case dismissViewController
}

public enum NavigationOptions: Equatable {
    
    case back
    case backToRoot
    case dismiss
    case leftMenu
    case logo
    case title
    case cart
    
    /*public static func ==(lhs: NavigationOptions, rhs: NavigationOptions) -> Bool {
     
     if lhs == rhs {
     return true
     }
     return false
     }*/
    
}

public extension UIViewController {
    
    //  MARK:- Setup navigation bar
    ///
    /// - Parameters:
    ///   As Cart, SideMenu, back button, app logo, title
    func setTopNavigation(for options: [NavigationOptions]) {
        
        var leftItems = [UIBarButtonItem]()
        var rightItems = [UIBarButtonItem]()
        
        if options.contains(.back) {
            leftItems.append(leftBarItem(for: ActionType.popViewController))
        } else if options.contains(.backToRoot) {
            leftItems.append(leftBarItem(for: ActionType.popToRootViewController))
        } else if options.contains(.dismiss) {
            leftItems.append(leftBarItem(for: ActionType.dismissViewController))
        }
        leftItems.append(fixedSpace(width: -7))
        self.navigationItem.setLeftBarButtonItems(leftItems, animated: false)
        
        if options.contains(.leftMenu) {
            setLeftMenuItem()
        }
        
        if options.contains(.cart) {
            self.navigationItem.leftBarButtonItems?.append(viewSpace())
            rightItems.append(cartButton())
        }
        
        if options.contains(.logo) {
            setLogoOnNavigation()
        }
        if options.contains(.title) {
            rightItems.append(viewSpace())
        }
        
        self.navigationItem.setRightBarButtonItems(rightItems, animated: false)
    }
    
    func setLogoOnNavigation() {
        
        let logo = UIImageView(image: AssetsImages.kAppLogoNavigation)
        logo.contentMode = UIViewContentMode.scaleAspectFit
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 30))
        logo.frame = titleView.bounds
        
        titleView.center = CGPoint(x: (self.navigationController?.navigationBar.width)! / 2.0, y: (self.navigationController?.navigationBar.height)! / 2.0)
        
        titleView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        
        titleView.addSubview(logo)
        self.navigationItem.titleView = titleView
    }
    
    private func leftBarItem(for type: ActionType) -> UIBarButtonItem {
        
        var leftButton = backButton()
        
        switch type {
        case .popViewController:
            leftButton.addTarget(self.navigationController, action: #selector(self.navigationController?.popViewController(animated:)), for : .touchUpInside)
            
        case .popToRootViewController:
            leftButton.addTarget(self.navigationController, action: #selector(self.navigationController?.popToRootViewController(animated:)), for : .touchUpInside)
            
        case .dismissViewController:
            leftButton = dismissButton()
            leftButton.addTarget(self, action: #selector(self.didTapDismiss(_:)), for: .touchUpInside)
        }
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    func setLeftMenuItem() {
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image: AssetsImages.kLeftMenuNavigation, style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.showLeftViewAnimated(_:)))
        navigationItem.leftBarButtonItem = leftButton
        
        //menutootle-icon
        //self.addLeftBarButtonWithImage(AssetsImages.kLeftMenuNavigation)
        //self.slideMenuController()?.removeLeftGestures()
       // self.slideMenuController()?.addLeftGestures()
        
        /*
        if self.userInterfaceLayoutDirection == .leftToRight {
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nevigation"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleLeft))
            navigationItem.leftBarButtonItem = leftButton
            self.slideMenuController()?.addLeftGestures()
        } else {
            
            let leftButton: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nevigation"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleRight))
            navigationItem.leftBarButtonItem = leftButton
            self.slideMenuController()?.addRightGestures()
        }
         */
    }
    
    //  MARK:- Change UIViewController navigation bar apperance.
    ///
    /// - Parameters:
    func setTransparentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func removeLeftNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        //self.slideMenuController()?.removeLeftGestures()
    }
    
    func removeNavigationBackButton()  {
        // remove left buttons (in case you added some)
        self.navigationItem.leftBarButtonItems = []
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
    }
    
    func hideNavigationBar()  {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationBar()  {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Navigation bar Private Methods
    private func backButton(with image: UIImage? = AssetsImages.kBack) -> UIButton {
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 15, height: 16)
        backButton.tintColor = UIColor.appDarkBlue
        backButton.setImage(image, for: .normal)
        return backButton
    }
    
    private func dismissButton(with image: UIImage? = AssetsImages.kBack) -> UIButton {
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.frame = CGRect(x: 0, y: 0, width: 15, height: 16)
        dismissButton.tintColor = UIColor.appDarkBlue
        dismissButton.setImage(image, for: .normal)
        return dismissButton
    }
    
    private func mapButton() -> UIBarButtonItem {
        
        let mapButton = UIButton(type: .custom)
        mapButton.frame = CGRect(x: 0, y: 0, width: 22, height: 17)
        mapButton.tintColor = UIColor.white
        //mapButton.setImage(AssetsImages.kMap, for: .normal)
        mapButton.addTarget(self, action: #selector(self.didTapMapItem(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: mapButton)
    }
    
    private func cartButton() -> UIBarButtonItem {
        
        let infoButton = UIButton(type: .custom)
        infoButton.frame = CGRect(x: 0, y: 0, width: 24, height: 22)
        infoButton.setImage(AssetsImages.kCart, for: .normal)
        infoButton.addTarget(self, action: #selector(self.didTapCart(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: infoButton)
    }
    
    func viewSpace() -> UIBarButtonItem {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 19))
        return UIBarButtonItem(customView: leftView)
    }
    
    func fixedSpace(width: CGFloat? = 18) -> UIBarButtonItem {
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = width! //18.0 // Set 26px of fixed space between the two UIBarButtonItems
        
        return fixedSpace
    }
    private func fixedSpaceButton() -> UIBarButtonItem {
        
        /// set the second navigation More button's
        let moreButton = UIButton(type: .custom)
        moreButton.frame = CGRect(x: 0, y: 0, width: 50, height: 52)
        return UIBarButtonItem(customView: moreButton)
    }
    
    // MARK: Actions
    @objc func didTapDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didTapBack(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func didTapBackToRoot(_ sender: UIButton) {
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //Add Delegate and funtion as registerListionerForMapButton() - add delegate as mapTapDelegate = self
    @objc func didTapMapItem(_ sender: UIButton) {
        
    }
    
     //Add Delegate and funtion as registerListionerForCartButton() - add delegate as cartTapDelegate = self
    @objc func didTapCart(_ sender: UIButton) {
        
    }
    
    func setTopNavigationBarTransparency() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage =  UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setNavigation(title: String) {
        
        /*
        let titleLabel = UILabel()
        titleLabel.frame = self.navigationController!.navigationBar.frame
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font: UIFont(font: .robotoBold, size: 18) ?? UIFont.systemFont(ofSize: 18),//Style.navigationBig.font,
//            NSAttributedStringKey.kern: CGFloat(2.0) //for add space between characters
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes:attributes as? [NSAttributedStringKey : Any])
        
        titleLabel.attributedText = attributedTitle
        self.navigationItem.titleView = titleLabel
        */
        
        let attributes = [NSAttributedStringKey.font :UIFont(font: .avenirBlack, size: 22) ?? UIFont.systemFont(ofSize: 22), NSAttributedStringKey.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = title
    }
    
    func setAttributedNavigationTitle(string: NSAttributedString) {
        let titleLabel = UILabel()//frame: CGRect(x: 0, y: 0, width: 200, height: 40)
        titleLabel.frame = self.navigationController!.navigationBar.frame
        titleLabel.textAlignment = .center
        
        titleLabel.attributedText = string
        //titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    
    func getAttributedString(text: String, string1: String, string2: String) -> NSAttributedString {
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font: UIFont(font: .avenirHeavy, size: 18) ?? UIFont.systemFont(ofSize: 18),//Style.navigationBig.font,
            NSAttributedStringKey.foregroundColor: UIColor.green,
            NSAttributedStringKey.kern:CGFloat(0.5)]
        let range1 = (text as NSString).range(of: string1)
        let range2 = (text as NSString).range(of: string2)
        let attributedTitle = NSMutableAttributedString(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: range1)
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray , range: range2)
        return attributedTitle
    }
    
    func hideNavigationBarBottomLine() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

// MARK: Keyboard Events

public extension UIViewController {
    
    func startObservingKeyboardEvents() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWasShown(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillBeHidden(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func stopObservingKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //create delegate for keyboard show and hide for viewcontroller and set delegate in startObservingKeyboardEvents()
    @objc func keyboardWasShown(_ notification: Notification) {
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        
    }
    
}

//MARK:- Email Invite
extension UIViewController : MFMailComposeViewControllerDelegate {
    
    func openMailComposer(toRecipent emailId: String? = "", subject: String, message: String? = "") {
        
        let mailCompose = MFMailComposeViewController()
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(message ?? "", isHTML: true)
        if let id = emailId {
            mailCompose.setToRecipients([id])
        }
        present(mailCompose, animated: true, completion: {})
    }
    
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        case .sent:
            Global.showAlert(withMessage: "Mail sent successfully")
        case .saved:
            printDebug("You saved a draft of this email")
        case .cancelled:
            printDebug("You cancelled sending this email.")
        case .failed:
            Global.showAlert(withMessage: "Mail failed: \([error!.localizedDescription])")
        }
        
        dismiss(animated: true, completion: {})
    }
}


// MARK: -  Social Share
extension UIViewController {
    
    func socialShare(with title: String?, image: UIImage?, url: URL?) {
        
        var items = [Any]()
        
        if let title = title {
            items.append(title)
        }
        if let image = image {
            items.append(image)
        }
        if let url = url {
            items.append(url)
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        //(UIActivityType?, Bool, [Any]?, Error?) -> Swift.Void
        activityVC.completionWithItemsHandler = {(activityType, completed: Bool, returnedItems:[Any]?, error: Error?) in
            
            // Return if cancelled
            guard completed == true else {
                return
            }
            //activity complete
            printDebug("Done")
            
        }
    }
}

// MARK: Get Previous ViewController

extension UIViewController {
    
    func getPreviousViewController() -> UIViewController? {
        guard let _ = self.navigationController else {
            return nil
        }
        guard let viewControllers = self.navigationController?.viewControllers else {
            return nil
        }
        guard viewControllers.count >= 2 else {
            return nil
        }
        return viewControllers[viewControllers.count - 2]
    }
}

extension UIViewController {
    func updateTabBarItemCounter (counterString : String?) {
        /*
         let badge = Global.getInt(for:counterString ?? 0 )
         Constants.kAppDelegate.user.cartCount = badge
         Constants.kAppDelegate.user.saveUser()
         if badge == 0 {
         Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeValue = nil
         }else {
         if let badgeValue = Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeValue {
         if #available(iOS 10.0, *) {
         Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeColor = UIColor.appYellow
         } else {
         // Fallback on earlier versions
         }
         Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeValue = counterString
         } else {
         if #available(iOS 10.0, *) {
         Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeColor = UIColor.appYellow
         } else {
         // Fallback on earlier versions
         }
         Constants.kAppDelegate.tabbarVC.tabBar.items?[3].badgeValue = counterString
         }
         }
         */
        
    }
}


extension UIViewController {
    
    func whatsup(share message:String, completionHandler:((_ finish:Bool)->Void)? = nil) {
        
        let urlWhats = "whatsapp://send?text=\(message)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            
            guard let url =  urlString.makeURL() else  {
                if completionHandler != nil {
                    completionHandler!(false)
                }
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, completionHandler: { (completed) in
                    if completionHandler != nil {
                        completionHandler!(completed)
                    }else {
                        Global.showAlert(withMessage: "Please install watsapp")
                    }
                })
            } else if UIApplication.shared.openURL(url) {
                completionHandler!(true)
            }else {
                print("Please install watsapp")
                completionHandler!(false)
            }
        }
    }
}

//MARK: - UIImagePickerController With Complition Handler.
extension UIViewController {
    
    private struct AssociatedKeys {
        //MARK: - UIImagePickerController Complition Handler.
        static var imageCompletionHandler:((UIImage?, Error?)-> Void)? = { image, error  in }
        static var videoCompletionHandler: ((URL?, Error?)-> Void)? = { url, error in }
    }
    
    private var imageCompletionHandler: ((UIImage?, Error?)-> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageCompletionHandler) as? ((UIImage?, Error?)-> Void)
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.imageCompletionHandler, newValue as ((UIImage?, Error?)-> Void)?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private var videoCompletionHandler: ((URL?, Error?)-> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.videoCompletionHandler) as? ((URL?, Error?)-> Void)
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.videoCompletionHandler, newValue as ((URL?, Error?)-> Void)?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    func openImagePickerWithForImage(completionHandler:@escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        let actionSheetController: UIAlertController = UIAlertController(title: Constants.kAppDisplayName, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel") //Cancel
        }
        actionSheetController.addAction(cancelActionButton)
        
        let captureVideoActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            print("Take Photo") //Will open Camera
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.delegate = self
                self.imageCompletionHandler = completionHandler
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("You don't have camera")
            }
            
        }
        actionSheetController.addAction(captureVideoActionButton)
        
        let gtalleryVideoActionButton: UIAlertAction = UIAlertAction(title: "Camera Roll", style: .default) { action -> Void in
            print("Camera Roll") //Will open Gallery
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                imagePicker.delegate = self
                self.imageCompletionHandler = completionHandler
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(gtalleryVideoActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openImagePickerForVideo(completionHandler:@escaping ((_ url: URL?, _ error: Error?) -> Void)) {
        let actionSheetController: UIAlertController = UIAlertController(title: Constants.kAppDisplayName, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel") //Cancel
        }
        actionSheetController.addAction(cancelActionButton)
        
        let captureVideoActionButton: UIAlertAction = UIAlertAction(title: "Capture Video", style: .default) { action -> Void in
            
            print("Capture Video") //Will open Camera
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.delegate = self
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                //imagePicker.videoMaximumDuration = 11
                //imagePicker.videoQuality = UIImagePickerControllerQualityType.typeMedium
                //imagePicker.cameraFlashMode = .off
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.video
                self.videoCompletionHandler = completionHandler
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("You don't have camera")
            }
            
        }
        actionSheetController.addAction(captureVideoActionButton)
        
        let gtalleryVideoActionButton: UIAlertAction = UIAlertAction(title: "Gallery Video", style: .default) { action -> Void in
            print("Gallery Video") //Will open Gallery
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imagePicker.delegate = self
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                self.videoCompletionHandler = completionHandler
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(gtalleryVideoActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func playVideoFrom(url:URL) {
        
        let player = AVPlayer(url: url)
        let playerController = AVPlayerViewController()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        //playerController.delegate = self
        
        playerController.player = player
        playerController.allowsPictureInPicturePlayback = true
        
        playerController.player?.play()
        self.present(playerController,animated:true,completion:nil)
    }
    
    func playVideoFrom(url:String) {
        if let url = URL(string: url) {
            self.playVideoFrom(url: url)
        }
    }
    
    func checkPhotoLibraryPermission(complition: ((_ result: Bool) -> Void)?) {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            complition?(true)
        } else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.showAlertForSettings(message: "Please give permission for access photo library.")
            complition?(false)
        } else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    complition?(true)
                } else {
                    complition?(false)
                }
            })
        } else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    func checkCameraPermission(complition: ((_ result: Bool) -> Void)?) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            complition?(true)
        } else if AVCaptureDevice.authorizationStatus(for: .video) ==  .denied {
            self.showAlertForSettings(message: "Please give permission to camera for capturing photos.")
            complition?(false)
        } else if AVCaptureDevice.authorizationStatus(for: .video) ==  .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    complition?(true)
                } else {
                    //access denied
                    complition?(false)
                }
            })
        }
    }
    
    fileprivate func showAlertForSettings(message:String) {
        self.presentAlertWith(message: message, oktitle: "Settings", okaction: {
            self.openSettingApp()
        }, notitle: "Cancel", noaction: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate delegate Protocol.
extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageCompletionHandler?(pickedImage, nil)
            
            //Clear handler
            imageCompletionHandler = nil
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            print(":::Video URL:::", videoURL)
            videoCompletionHandler?(videoURL, Errors.unknown)
            
            //Clear handler
            videoCompletionHandler = nil
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageCompletionHandler?(nil, Errors.unknown)
        videoCompletionHandler?(nil, Errors.unknown)
        
        //Clear handler
        imageCompletionHandler = nil
        videoCompletionHandler = nil
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - AVPlayerViewControllerDelegate delegate Protocol.
extension UIViewController: AVPlayerViewControllerDelegate {
    
    func didfinishplaying(note : NSNotification) {
        //playerViewController.dismiss(animated: true,completion: nil)
    }
    
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        let currentviewController =  navigationController?.visibleViewController
        
        if currentviewController != playerViewController
        {
            currentviewController?.present(playerViewController,animated: true,completion:nil)
        }
    }
}


