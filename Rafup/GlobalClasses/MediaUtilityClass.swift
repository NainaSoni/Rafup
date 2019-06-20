

import UIKit
import Foundation
// Add library in your project
import AVFoundation
import MediaPlayer
import MobileCoreServices


/*
*  Key for plist file -
1. Privacy - Media Library Usage Description
2. Privacy - Camera Usage Description
3. Privacy - Photo Library Usage Description
*
*
*/

class MediaUtilityClass: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MPMediaPickerControllerDelegate
{
	//MARK:- Local class property
	static var mediaUtility : MediaUtilityClass!
	
	//MARK:- Local instance property
	var imgPickerController : UIImagePickerController!
	var mpMediaPicker       : MPMediaPickerController!
	
    var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
	var mediaItems = [MPMediaItem]()
	
	
	//MARK:- Local variable for hold completion block
	private var imageCompletionHandler: (UIImage?,NSURL?, NSError?)-> Void = { image,url,error  in }
	private var mediaCompletionHandler: (NSURL?, NSError?)-> Void = { url,error  in }
	
	//MARK:- Singleton object
	/*
	*    Below method is used to access singlton object of MediaUtility.
	*/
	class func sharedInstanse() -> MediaUtilityClass {
		if mediaUtility == nil {
			mediaUtility = MediaUtilityClass()
		}
		return mediaUtility
	}
        
	// MARK:- ImagePicker with actionSheet for image
	/*
	*    Below method is used to show image picker options.
	*	 Option are - 1. Photo library  2. Camera
	*/
    func pickImage(message:String = "Select option",completionHandler:  @escaping (_ image: UIImage?,_ imageURL:NSURL?, _ error: NSError?) -> ())
	{
		//Hold completion handler
		imageCompletionHandler = completionHandler
		
		//option selection
		let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .actionSheet)
		
		imgPickerController = UIImagePickerController()
		
		let photoAction = UIAlertAction.init(title: "Photo library", style: .default) { (alert: UIAlertAction) in
			//call helper function
			self.showImagePickerWith(type: .photoLibrary)
		}
		
		let cameraAction = UIAlertAction.init(title: "Camera", style: .default) { (alert: UIAlertAction) in
			//call helper function
			self.cameraOptionSelected()
		}
		
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
		}
		
		alert.addAction(photoAction)
		alert.addAction(cameraAction)
		alert.addAction(cancelAction)
		
		guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
			return
		}
		
		rootViewController.present(alert, animated: true, completion: nil)
	}
    
    
	// MARK:- ImagePicker using camera only
	/*
	*    Below method is used to get image using camera only.
	*/
	func pickImageUsingCamera(completionHandler:  @escaping (_ image: UIImage?,_ imageURL:NSURL?, _ error: NSError?) -> ())
	{
		//Hold completion handler
		imageCompletionHandler = completionHandler
		imgPickerController = UIImagePickerController()
		self.cameraOptionSelected()
	}
    
	// MARK:- Pick audio song with style sheet
	/*
	*    Below method is used to pick audio using MPMediaPickerController.
	*/
	func pickAudio(completionHandler:  @escaping (_ songURL: NSURL?, _ error: NSError?) -> ()) {
		
		//Hold completion handler
		mpMediaPicker = MPMediaPickerController()
		
		let optionMenu = UIAlertController.init(title: nil, message: "Select", preferredStyle: .actionSheet)
		
		let audioAction = UIAlertAction.init(title: "Audio", style: .default) { (alert: UIAlertAction) in
			
			self.presentAudioPicker()
		}
		
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
		}
		
		mediaCompletionHandler = completionHandler
		optionMenu.addAction(audioAction)
		optionMenu.addAction(cancelAction)
		
		guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
			return
		}
		rootViewController.present(optionMenu, animated: true, completion: nil)
	}
    
	//MARK:- Showing Audio picker
	/*
	*    Below method is used to Pick Audio.
	*/
	func presentAudioPicker()
	{
		self.mpMediaPicker = MPMediaPickerController.init(mediaTypes: .anyAudio)
		self.mpMediaPicker.delegate = self
		// If you want select multiple songs then change the status to 'true'
		self.mpMediaPicker.allowsPickingMultipleItems = false
		
		guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
			return
		}
		rootViewController.present(self.mpMediaPicker, animated: true, completion: nil)
	}
	
	// MARK:- Pick Video song with action sheet
	/*
	*    Below method is used to Pick Video song with action sheet.
	*/
	func pickVedio(completionHandler:  @escaping (_ songURL: NSURL?, _ error: NSError?) -> ())
	{
		//Hold completion handler
		imgPickerController = UIImagePickerController()
		
		let optionMenu = UIAlertController.init(title: nil, message: "Select", preferredStyle: .actionSheet)
		
		let vedioAction = UIAlertAction.init(title: "Video", style: .default) { (alert: UIAlertAction) in
			
			self.presentVideoPicker()
		}
		
		let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel) { (alert: UIAlertAction) in
		}
		
		mediaCompletionHandler = completionHandler
		optionMenu.addAction(vedioAction)
		optionMenu.addAction(cancelAction)
		
		guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
			return
		}
		rootViewController.present(optionMenu, animated: true, completion: nil)
	}
    
	//MARK:- Showing Video picker
	/*
	*    Below method is used as helping method to show video picker.
	*/
	private func presentVideoPicker()
	{
		self.imgPickerController.sourceType = .savedPhotosAlbum
		self.imgPickerController.mediaTypes =  [kUTTypeMovie as String]
		self.imgPickerController.delegate = self
		
		guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
			return
		}
		rootViewController.present(self.imgPickerController, animated: true, completion: nil)
	}
	
	// MARK:- ImagePicker delegate
	/*
	*    Below methods are Delegate methods of UIImagePickerControllerDelegate.
	*    These are called as per user respond like cancel, pick any image and click done.
	*/
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
		{
			
			DispatchQueue.main.async {
				
				let imageURL=info[UIImagePickerControllerReferenceURL] as? NSURL
				self.imageCompletionHandler(pickedImage,imageURL,nil)
			}
		}
		else
		{
			let pickedVedioURL = info[UIImagePickerControllerMediaURL] as? NSURL
			
			DispatchQueue.main.async {
				
				self.mediaCompletionHandler(pickedVedioURL, nil)
			}
			
			print(":::Video song URL:::", pickedVedioURL!)
		}
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
		self.imageCompletionHandler(nil,nil,nil)
	}
	
	// MARK:- MediaPicker delegate
	/*
	*    Below methods are Delegate methods of MediaPicker Delegate.
	*    These are called as per user respond like cancel, pick any image and click done.
	*/
	func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
	{
		musicPlayer.stop()
		mediaPicker.dismiss(animated: true, completion: nil)
		
		mediaItems = mediaItemCollection.items
		
		for selectedItem in mediaItemCollection.items as [MPMediaItem]
		{
			let itemUrl = selectedItem.value(forProperty: MPMediaItemPropertyAssetURL) as? NSURL
			
			DispatchQueue.main.async {
				
				self.mediaCompletionHandler(itemUrl, nil)
			}
			
			print(":::Audio song URL:::", itemUrl!)
		}
		
		/*
		*
		*  Follow code is for play audio song
		*
		
		do {
		let player = MPMusicPlayerController.applicationMusicPlayer()
		player.setQueue(with: mediaItemCollection)
		musicPlayer.play()
		// Your code here if you want slider with timer
		}
		*/
	}
	
	func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
		mediaPicker.dismiss(animated: true, completion: nil)
	}
	
	// Dispose singleton object
	func distroySingleton() {
		if MediaUtilityClass.mediaUtility != nil {
			MediaUtilityClass.mediaUtility = nil
		}
	}
	
}

//MARK:- ImagePicker general functions
extension MediaUtilityClass
{
	/*
	*    Below method is helping method to check request authorization status and take decision accordingly.
	*
	*/
	fileprivate func cameraOptionSelected()
	{
		if UIImagePickerController.isSourceTypeAvailable(.camera)
		{
			
			// Camera authorization
			/*
			     Note :- If you see error like "Incorrect argument label in call (have 'for:', expected 'forMediaType:')"  then replace
			
			     AVMediaTypeVideo --->>> "AVMediaType.video"
			*/
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (success) in
				
				if success
				{
                    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
					
					switch authStatus
					{
					case .authorized:
						//call helper function
						self.showImagePickerWith(type: .camera)
						
					default: //  case .denied OR  case .notDetermined
						
						guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
							return
						}
						rootViewController.showCameraPermissionAlert()
					}
				}
				else{
					
					DispatchQueue.main.async
						{
							guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
								return
							}
							rootViewController.showCameraPermissionAlert()
					}
				}
			})
			
		}
		else
		{
			guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
				return
			}
			
			rootViewController.presentAlertWith(message:"Camera not found")
		}
	}
    
	//MARK:- Present Picker
	func showImagePickerWith(type:UIImagePickerControllerSourceType)
	{
		imgPickerController.sourceType = type
		imgPickerController.delegate   = self
		
		DispatchQueue.main.async(execute: {
			
			guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
				return
			}
			rootViewController.present(self.imgPickerController, animated: true, completion: nil)
		})
		
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extension UIViewController
{
	func showCameraPermissionAlert()
	{
		let systemVersion : NSString  = UIDevice.current.systemVersion as NSString
		if systemVersion.floatValue >= 8.0
		{
			let alert=UIAlertController(title: "Oops", message: "Camera permission not enabled. Do you want to give permission?", preferredStyle: .alert)
			
			let yes=UIAlertAction(title: "Yes", style: .default) { (action) in
				self.openSettingApp()
			}
			
			let no=UIAlertAction(title: "No", style: .cancel, handler: nil)
			
			alert.addAction(no)
			alert.addAction(yes)
			
			guard  let rootViewController=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
				return
			}
			
			rootViewController.present(alert, animated: true, completion: nil)
		}
	}
}

