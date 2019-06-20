//
//  UINavigationControllerExtension.swift
//  AirPool
//
//  Created by Ashish on 09/01/18.
//  Copyright © 2018 DS. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    //  MARK:- pop back to specific viewcontroller
    
    //self.popBack(toControllerType: MyViewController.self)
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }
    
    //  MARK:- pop back n viewcontroller
    func popBack(_ nb: Int) {
        let viewControllers: [UIViewController] = self.viewControllers
        guard viewControllers.count < nb else {
            self.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
            return
        }
        
        //        if let viewControllers: [UIViewController] = self.viewControllers {
        //            guard viewControllers.count < nb else {
        //                self.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
        //                return
        //            }
        //        }
    }
    
    //  MARK:- Set or remove back button title.
    func removeBackButtonTitle()  {
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = nil
        self.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setBackButtonTitle(titles:String)  {
        let backButton = UIBarButtonItem()
        backButton.title = titles
        self.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func removeViewController<T: UIViewController>(ofControllerType: T.Type)  {
        var viewControllers: [UIViewController] = self.viewControllers
        var index = 0
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: ofControllerType) {
                viewControllers.remove(at: index)
                break
            }
            index = index + 1
        }
    }
    
    //MARK:- Pop ViewController with completion handler.
    ///
    /// - Parameter completion: optional completion handler (default is nil).
    public func popViewController(_ completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: true)
        CATransaction.commit()
    }
    
    //MARK:- Push ViewController with completion handler.
    ///
    /// - Parameters:
    ///   - viewController: viewController to push.
    ///   - completion: optional completion handler (default is nil).
    public func pushViewController(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        // https://github.com/cotkjaer/UserInterface/blob/master/UserInterface/UIViewController.swift
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
    
    //MARK:- Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    public func makeTransparent(withTint tint: UIColor = .white) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = tint
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: tint]
    }
}

