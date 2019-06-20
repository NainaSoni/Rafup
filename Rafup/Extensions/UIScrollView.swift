//
//  UIScrollView.swift
//  PocketSeed
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)+1
    }
}
