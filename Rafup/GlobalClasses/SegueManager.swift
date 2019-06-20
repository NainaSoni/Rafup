//
//  SegueManager.swift
//  Rafup
//
//  Created by Ashish on 26/10/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

/*
 
 Make UIViewController as subclass of SegueManager
 
 self.performSeguewithIdentifier(Identifier: SecondViewController.className) { (viewController) in
 if let secondVc = viewController as? SecondViewController {
 print(secondVc)
 }
 }
 
 */

class SegueManager: UIViewController {
    
    var completionHandler:((UIViewController?) -> Void)?
    
    func performSeguewithIdentifier(Identifier identifier: String, completion: ((UIViewController?) -> Void)?) {
        if let handler = completion {
            completionHandler = handler
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        completionHandler?(segue.destination)
        self.completionHandler = nil
    }
    
}
