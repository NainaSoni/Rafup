//
//  AppManager.swift
//  Underwrite-it
//
//  Created by Ashish on 16/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import MobileCoreServices

class AppManager: NSObject {
    
    
    //MARK: - Shared Instance
    static let shared : AppManager = {
        let instance = AppManager()
        // setup code
        return instance
    }()
    
    //MARK: - UIImagePickerController Complition Handler.
    var imageCompletionHandler: ((UIImage?, Error?)-> Void)? = { image, error  in }
    var mediaCompletionHandler: ((URL?, Error?)-> Void)? = { url, error in }
    
    // MARK: - Open ImagePcker with gallery images.
    func openGallaryWithImage(viewController: UIViewController? = UIApplication.topViewController(),completionHandler:@escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.delegate = self
            self.imageCompletionHandler = completionHandler
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: - Open ImagePcker with camera capture image.
    func openCameraWithCaptureImage(viewController: UIViewController? = UIApplication.topViewController(),completionHandler:@escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            self.imageCompletionHandler = completionHandler
            imagePicker.allowsEditing = true
            viewController?.present(imagePicker, animated: true, completion: nil)
        } else {
           print("You don't have camera")
        }
    }
    
    // MARK: - Open ImagePcker with gallery videos.
    func openGallaryWithVideo(viewController: UIViewController? = UIApplication.topViewController(),completionHandler:@escaping ((_ url: URL?, _ error: Error?) -> Void)) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.mediaCompletionHandler = completionHandler
            viewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
     // MARK: - Open ImagePcker with capture video.
    func openCameraWithCaptureVideo(viewController: UIViewController? = UIApplication.topViewController(),completionHandler:@escaping ((_ url: URL?, _ error: Error?) -> Void)) {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.delegate = self
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            //imagePicker.videoMaximumDuration = 11
            //imagePicker.videoQuality = UIImagePickerControllerQualityType.typeMedium
            //imagePicker.cameraFlashMode = .off
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.video
            self.mediaCompletionHandler = completionHandler
            viewController?.present(imagePicker, animated: true, completion: nil)
        } else {
            print("You don't have camera")
        }
    }
    
    // MARK: - Add navigation back button with pop -2 Method.
    func addleftBarItemWithDoublePop(sender:UIViewController) {
        func backButton(with image: UIImage? = AssetsImages.kBack) -> UIButton {
            
            let backButton = UIButton(type: .custom)
            backButton.frame = CGRect(x: 0, y: 0, width: 15, height: 16)
            backButton.tintColor = UIColor.appDarkBlue
            backButton.addTarget(self, action: #selector(self.doublePoPNavigation(sender:)), for : .touchUpInside)
            backButton.setImage(image, for: .normal)
            return backButton
        }
         sender.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton()), animated: false)
    }
    
    @objc private func doublePoPNavigation(sender:UIViewController) {
        sender.navigationController?.popBack(2)
    }
    
    // MARK: - Login Remember Me Method.
    static func isRememberobject(email emailStr: String , passwordStr: String, isRemeber:Bool ) {
        if isRemeber {
            UserDefaults.standard.set(emailStr, forKey: "EMAIL")
            UserDefaults.standard.set(passwordStr, forKey: "PASSWORD")
            UserDefaults.standard.set(true, forKey: "ISREMEMBER")
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.removeObject(forKey: "EMAIL")
            UserDefaults.standard.removeObject(forKey: "PASSWORD")
            UserDefaults.standard.removeObject(forKey: "ISREMEMBER")
            UserDefaults.standard.synchronize()
        }
    }
    
    static func getEmail() -> String? {
        return UserDefaults.standard.object(forKey: "EMAIL") as? String
    }
    
    static func getPassword() -> String? {
        return UserDefaults.standard.object(forKey: "PASSWORD") as? String
    }
    
    static func isRemember() -> Bool {
        print(UserDefaults.standard.bool(forKey: "ISREMEMBER"))
        if !UserDefaults.standard.bool(forKey: "ISREMEMBER") == true {
            return false
        } else {
            return true
        }
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate delegate Protocol.
extension AppManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("selected image #: \(pickedImage)")
            imageCompletionHandler?(pickedImage, nil)
            imageCompletionHandler = nil
        } else if let videoURL = info[UIImagePickerControllerMediaURL] as? URL {
            print(":::Video URL:::", videoURL)
            mediaCompletionHandler?(videoURL, Errors.unknown)
            mediaCompletionHandler = nil
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageCompletionHandler?(nil, Errors.unknown)
        mediaCompletionHandler?(nil, Errors.unknown)
        
        imageCompletionHandler = nil
        mediaCompletionHandler = nil
        picker.dismiss(animated: true, completion: nil)
    }
}
