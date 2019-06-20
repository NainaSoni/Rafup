//
//  DoubleExtension.swift
//  AirPool
//
//  Created by Ashish on 01/03/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var clean: String {
       // return String(format: "%.1f", self)
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.1f", self) : String(self)
    }
}
