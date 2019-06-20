//
//  UIImageView.swift
//  Underwrite-it
//
//  Created by Ashish on 09/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit
import Foundation

private let imageCache = NSCache<NSString, AnyObject>()
private var activityIndicatorAssociationKey: UInt8 = 0

extension UIImageView {
    
    //MARK:- Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    public func blur(withStyle style: UIBlurEffectStyle = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    //MARK:- Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    public func blurred(withStyle style: UIBlurEffectStyle = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
    
    //MARK:- Add gradient to image view as bottom to up side.
    public func setBottomUpGradientLayer(frame: CGRect, colors:[UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{$0.cgColor}
        // gradient.locations = [0.0, 0.1]
        self.layer.addSublayer(gradient)
        // self.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:- Set Tint colour to image.
    public var tint: UIColor {
        set {
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = newValue
        }
        get {
            return self.tint
        }
    }
    
    //MARK:- Set image from a URL with completion Handler.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    public func setImageWithURL(url: URL, placeholder: UIImage? = nil, isCache:Bool = true, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        self.image = placeholder
        
        // check cached image
        if isCache {
            if let cachedImage = imageCache.object(forKey: url.path as NSString) as? UIImage {
                self.image = cachedImage
                handler?(cachedImage, nil)
                return
            }
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                if handler != nil  { handler!(nil, error) }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.path as NSString)
                    if handler != nil  { self.image  = image; handler?(image, nil) } else {
                        self.image = image
                    }
                }
            }
            
        }).resume()
        
        
        /*
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    handler?(nil, error)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                handler?(image, nil)
            }
            }.resume()
         */
    }
    
    public func setImageWithURL(url: URL, placeholder: UIImage? = nil, isCache:Bool = true, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        
        //Set imageview content mode
        contentMode = mode
        
        self.image = placeholder
        
        // check cached image
        if isCache {
            if let cachedImage = imageCache.object(forKey: url.path as NSString) as? UIImage {
                self.image = cachedImage
                return
            }
        }
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.path as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
    
    public func setImageWithURL(url: String, placeholder: UIImage?, isCache:Bool = true, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        guard let url = URL(string: url) else { if handler != nil  { handler!(nil, Errors.invalidURL) }; return }
        setImageWithURL(url: url, placeholder: placeholder, isCache: isCache, handler: handler)
    }
    
    public func setImageWithURL(url: String, placeholder: UIImage?, isCache:Bool = true, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: url) else { return }
        setImageWithURL(url: url, placeholder: placeholder, isCache:isCache, contentMode:mode)
    }
    
    public func setImageWithURL(url: URL, isCache:Bool = true) {
        self.setImageWithURL(url: url, placeholder: nil, isCache: isCache, handler: nil)
    }
    
    public func setImageWithURL(url: String, isCache:Bool = true) {
        guard let url = URL(string: url) else { return }
        self.setImageWithURL(url: url, placeholder: nil, isCache: isCache, handler: nil)
    }
    
    public func setImageWithURL(url: URL, withGifIndicator gif:String, isCache: Bool = true,  handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        let localPathGif = UIImage.gifImageWithName(gif) // Local path gif name

        self.setImageWithURL(url: url, placeholder: localPathGif, isCache: isCache, handler: handler)

    }
    
    public func setImageWithURL(url: String, withGifIndicator gif:String, isCache: Bool = true,  handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        guard let url = URL(string: url) else { if handler != nil  { handler!(nil, Errors.invalidURL) }; return }
        
        let localPathGif = UIImage.gifImageWithName(gif) // Local path gif name
        
        self.setImageWithURL(url: url, placeholder: localPathGif, isCache: isCache, handler: handler)
        
    }
    
    public func setImageWithActivityIndicator(withURL url: URL, placeholder: UIImage?, isCache:Bool = true, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        self.image = placeholder
        
        self.showActivityIndicator()
        
        // check cached image
        if isCache {
            if let cachedImage = imageCache.object(forKey: url.path as NSString) as? UIImage {
                self.image = cachedImage
                handler?(cachedImage, nil)
                return
            }
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                if handler != nil  { handler!(nil, error) }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: url.path as NSString)
                    self.stopAnimating()
                    if handler != nil  { self.image  = image; handler?(image, nil) } else {
                        self.image = image
                    }
                }
            }
            
        }).resume()
    }
    
    public func setImageWithActivityIndicator(withURL url: String, placeholder: UIImage?, isCache:Bool = true, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        guard let url = URL(string: url) else { if handler != nil  { handler!(nil, Errors.invalidURL) }; return }
        self.setImageWithActivityIndicator(withURL: url, placeholder: placeholder,isCache:isCache, handler: handler)
    }
    
    /*
    fileprivate func loadImageFromSDWebImage(with url:URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        self.kf.setImage(with: url, placeholder: placeholder, options: [], progressBlock: nil) { (image, error, type, url) in
            guard let anImage = image else {
                if handler != nil  { handler!(nil, error) }
                //handler!(nil, error)
                return
            }
            if handler != nil  { handler!(anImage, nil) }
            //handler!(anImage, nil)
        }
    }
     */
    
    fileprivate func loadImageFromURLRequest(with url:URL, placeholder: UIImage?, handler:((_ image:UIImage?, _ error:Error?)->Void)?) {
        
        let request = URLRequest(url: url)
        
        let task : URLSessionDownloadTask = URLSession.shared.downloadTask(with: request) { (url, response, error) in
            guard let fileURL  = url , let anImage  = UIImage(contentsOfFile: fileURL.path) else {
                if handler != nil  { handler!(nil, error) }
                return
            }
            DispatchQueue.main.async(execute: {
                self.image = anImage
                if handler != nil  {handler!(anImage, nil) }
            })
        }
        task.resume()
    }
}

//MARK:- Add imageview with UIActivityIndicatorView.
private extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private func showActivityIndicator() {
        
        if (self.activityIndicator == nil) {
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
            self.activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.activityIndicator.autoresizingMask = [.flexibleLeftMargin , .flexibleRightMargin , .flexibleTopMargin , .flexibleBottomMargin]
            self.activityIndicator.isUserInteractionEnabled = false
            
            OperationQueue.main.addOperation({ () -> Void in
                self.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
            })
        }
    }
    
    
    private func hideActivityIndicator() {
        OperationQueue.main.addOperation({ () -> Void in
            self.activityIndicator.stopAnimating()
        })
    }
}

extension UIImage {
    
    func base64String() -> String {
        let strBase64 =  self.mediumQualityJPEGNSData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
}

