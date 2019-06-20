//
//  LinkTextView.swift
//  Nafas
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Here is the protocol for textfield link tap.
protocol LinkTextViewDelegate{
    
    func textViewLinkPressed(textView:UITextView, text:String)
}

class LinkTextView: UITextView, UITextViewDelegate {
    
    var linkDelegate:LinkTextViewDelegate!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.isEditable                     = false
        self.isSelectable                   = true
        self.isUserInteractionEnabled       = true
        self.dataDetectorTypes              = .link
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator   = false
        self.isScrollEnabled                = false
        self.contentOffset                  = CGPoint.zero
        self.contentInset                   = UIEdgeInsets.zero
        self.textContainerInset             = UIEdgeInsets.zero
        self.scrollIndicatorInsets          = UIEdgeInsets.zero
        //self.textContainer.lineFragmentPadding = 0
        
        //self.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.red]
        self.delegate = self
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString.hasPrefix(Constants.kAppDisplayName + "://") {
            guard let value = URL.absoluteString.removingPercentEncoding else {
                return false
            }
            // Get range of all characters past the first Constants.kAppDisplayName.count + 3.
            let index = value.index(value.startIndex, offsetBy: Constants.kAppDisplayName.count + 4) // Text After ` Constants.kAppDisplayName.count://`
            let decodedText  = String(value[..<index])
            guard  self.linkDelegate != nil else {
                return false
            }
            self.linkDelegate.textViewLinkPressed(textView: self, text: decodedText)
        }
        return true
    }
}

extension NSMutableAttributedString {
    /*
            Set text with link Url
     */
    func setTextAsLink(textToFind:String! , withLink:NSURL! = nil) ->Bool {
        guard textToFind != nil else {
            return false
        }
        
        let range:NSRange = self.mutableString.range(of: textToFind, options: NSString.CompareOptions.caseInsensitive)
        if range.location == NSNotFound {
            return false
        }else {
            if  withLink == nil {
                let urlEncodedQuery = (Constants.kAppDisplayName + "://" + textToFind).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                let url:NSURL = NSURL(string: urlEncodedQuery!)!
                self.addAttribute(NSAttributedStringKey.link, value: url, range: range)
            }else{
                self.addAttribute(NSAttributedStringKey.link, value: withLink, range: range)
            }
            return true
        }
    }
}
