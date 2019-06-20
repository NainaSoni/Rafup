//
//  CLLocationCoordinate2DExtension.swift
//  AirPool
//
//  Created by Ashish on 01/03/18.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationCoordinate2D {
    func isEqual(_ coord: CLLocationCoordinate2D) -> Bool {
        let Lastlat = self.latitude.rounded(toPlaces: 4)
        let Lastlong = self.longitude.rounded(toPlaces: 4)
        let mylat = coord.latitude.rounded(toPlaces: 4)
        let mylong = coord.longitude.rounded(toPlaces: 4)
        return (fabs(Lastlat - mylat) < .ulpOfOne) && (fabs(Lastlong - mylong) < .ulpOfOne)
    }
}

extension CLLocationCoordinate2D: Equatable {
    
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
}
