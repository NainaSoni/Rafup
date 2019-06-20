//
//  GlobalLocationTracker.swift
//  Fodder
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Here is the protocol for didUpdate location.
protocol LocationTrackerDelegate: class {
    
    func didUpdate(withLocation location: CLLocation)
}

public class LocationTracker: NSObject {
    
    enum LocationErrors: String {
        case denied = "Locations are turned off. Please turn it on in Settings"
        case restricted = "Locations are restricted"
        case notDetermined = "Locations are not determined yet"
        case notFetched = "Unable to fetch location"
        case invalidLocation = "Invalid Location"
        case reverseGeocodingFailed = "Reverse Geocoding Failed"
    }
    
    typealias LocationClosure = ((_ location:CLLocation?,_ error: NSError?)->Void)
    private var locationCompletionHandler: LocationClosure?
    
    typealias ReverseGeoLocationClosure = ((_ location:CLLocation?, _ placemark:CLPlacemark?,_ error: NSError?)->Void)
    private var geoLocationCompletionHandler: ReverseGeoLocationClosure?
    
//    static let shared = LocationTracker()
    static let shared : LocationTracker = {
        let instance = LocationTracker()
        // setup code
        return instance
    }()
    
    weak var delegate: LocationTrackerDelegate?

    var currentLocation: CLLocation?
    
    private var reverseGeocoding = false
    private var isUpdatingLocation = false

    private let locationManager: CLLocationManager = {
        // Initialize Location Manager
        let locationManager = CLLocationManager()
        
        // Configure Location Manager
        /* Pinpoint our location with the following accuracy:
         *
         *     kCLLocationAccuracyBestForNavigation  highest + sensor data
         *     kCLLocationAccuracyBest               highest
         *     kCLLocationAccuracyNearestTenMeters   10 meters
         *     kCLLocationAccuracyHundredMeters      100 meters
         *     kCLLocationAccuracyKilometer          1000 meters
         *     kCLLocationAccuracyThreeKilometers    3000 meters
         */
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        /* Notify changes when device has moved x meters.
         * Default value is kCLDistanceFilterNone: all movements are reported.
         */
        locationManager.distanceFilter = 10.0
        
        /* Notify heading changes when heading is > 5.
         * Default value is kCLHeadingFilterNone: all movements are reported.
         */
        locationManager.headingFilter = 5
        
         //locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
        locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
        
        return locationManager
    }()
    
    override init() {
        super.init()
        /*
         *  Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
        */
    }
    
    func requestUpdating() {
        // Configure Location Manager
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Request Current Location
            locationManager.startUpdatingLocation()
        } else {
            // Request Authorization
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    func stopUpdating() {
        // Reset Delegate
        LocationTracker.shared.locationManager.delegate = nil
        // Stop Location Manager
        LocationTracker.shared.locationManager.stopUpdatingLocation()
    }
    
    /// Get current location
    ///
    /// - Parameter completionHandler: will return CLLocation object which is the current location of the user and NSError in case of error
    func getCurrentLocation(completionHandler:@escaping LocationClosure) {
        
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.locationCompletionHandler = completionHandler
        
        //check previous updating location or not.
        isUpdatingLocation = (locationManager.delegate != nil)
        
        if currentLocation != nil {
            self.locationCompletionHandler?(currentLocation,nil)
        } else {
            requestUpdating()
        }
    }
    
    func stopGetCurrentLocation() {
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.locationCompletionHandler = nil
        
        stopUpdating()
    }
    
    /// Get Reverse Geocoded Placemark address by passing CLLocation
    ///
    /// - Parameters:
    ///   - location: location Passed which is a CLLocation object
    ///   - completionHandler: will return CLLocation object and CLPlacemark of the CLLocation and NSError in case of error
    func getReverseGeoCodedLocation(location:CLLocation,completionHandler:@escaping ReverseGeoLocationClosure) {
        
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.geoLocationCompletionHandler = nil
        
        self.geoLocationCompletionHandler = completionHandler
        
        if !reverseGeocoding {
            reverseGeocoding = true
            self.reverseGeoCoding(location: location)
        }
        
    }
    
    /// Get Latitude and Longitude of the address as CLLocation object
    ///
    /// - Parameters:
    ///   - address: address given by the user in String
    ///   - completionHandler: will return CLLocation object and CLPlacemark of the address entered and NSError in case of error
    func getGeoCodedLocation(address:String,completionHandler:@escaping ReverseGeoLocationClosure) {
        
        //Cancelling the previous selector handlers if any
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        
        self.geoLocationCompletionHandler = nil
        
        self.geoLocationCompletionHandler = completionHandler
        
        if !reverseGeocoding {
            reverseGeocoding = true
            self.reverseGeoCoding(address: address)
        }
    }
    
    //MARK:- Reverse GeoCoding
    private func reverseGeoCoding(location:CLLocation?) {
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                //Reverse geocoding failed
                self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code:Int(CLAuthorizationStatus.denied.rawValue),
                    userInfo:
                    [NSLocalizedDescriptionKey:LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedFailureReasonErrorKey:LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedRecoverySuggestionErrorKey:LocationErrors.reverseGeocodingFailed.rawValue]))
                return
            }
            if placemarks!.count > 0 {
                let placemark = placemarks![0]
                if let _ = location {
                    self.didCompleteGeocoding(location: location, placemark: placemark, error: nil)
                } else {
                    self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                        domain: self.classForCoder.description(),
                        code:Int(CLAuthorizationStatus.denied.rawValue),
                        userInfo:
                        [NSLocalizedDescriptionKey:LocationErrors.invalidLocation.rawValue,
                         NSLocalizedFailureReasonErrorKey:LocationErrors.invalidLocation.rawValue,
                         NSLocalizedRecoverySuggestionErrorKey:LocationErrors.invalidLocation.rawValue]))
                }
                if(!CLGeocoder().isGeocoding){
                    CLGeocoder().cancelGeocode()
                }
            }else{
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    private func reverseGeoCoding(address:String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: {(placemarks, error)->Void in
            if (error != nil) {
                //Reverse geocoding failed
                self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                    domain: self.classForCoder.description(),
                    code:Int(CLAuthorizationStatus.denied.rawValue),
                    userInfo:
                    [NSLocalizedDescriptionKey:LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedFailureReasonErrorKey:LocationErrors.reverseGeocodingFailed.rawValue,
                     NSLocalizedRecoverySuggestionErrorKey:LocationErrors.reverseGeocodingFailed.rawValue]))
                return
            }
            if placemarks!.count > 0 {
                if let placemark = placemarks?[0] {
                    self.didCompleteGeocoding(location: placemark.location, placemark: placemark, error: nil)
                } else {
                    self.didCompleteGeocoding(location: nil, placemark: nil, error: NSError(
                        domain: self.classForCoder.description(),
                        code:Int(CLAuthorizationStatus.denied.rawValue),
                        userInfo:
                        [NSLocalizedDescriptionKey:LocationErrors.invalidLocation.rawValue,
                         NSLocalizedFailureReasonErrorKey:LocationErrors.invalidLocation.rawValue,
                         NSLocalizedRecoverySuggestionErrorKey:LocationErrors.invalidLocation.rawValue]))
                }
                if(!CLGeocoder().isGeocoding){
                    CLGeocoder().cancelGeocode()
                }
            }else{
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    private func didCompleteGeocoding(location:CLLocation?,placemark: CLPlacemark?,error: NSError?) {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        geoLocationCompletionHandler?(location,placemark,error)
        reverseGeocoding = false
    }
}

/*
 //MARK:- CLLocationManagerDelegate
 */

extension LocationTracker: CLLocationManagerDelegate {
    
    // MARK: - Location Updates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else {
            return
        }
        //printDebug("didUpdateLocations \(location)")
        
        // Stop Location Manager and Reset Delegate
        //LocationTracker.shared.stopUpdating()
        
        guard let current = currentLocation else {
            // Update Current Location
            currentLocation = location
            delegate?.didUpdate(withLocation: location)
            return
        }
        guard location.coordinate != current.coordinate else {
            return
        }
        
        // Update Current Location
        currentLocation = location
        
        self.locationCompletionHandler?(location,nil)
        
        delegate?.didUpdate(withLocation: location)
        
        if !isUpdatingLocation {
            stopGetCurrentLocation()
        } else {
            //if you want clouser call again and again according to didupdate location then remove else condition.
            self.locationCompletionHandler = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug("didFailWithError \(error.localizedDescription)")
        self.locationCompletionHandler?(nil,error as NSError)
        
        if !isUpdatingLocation {
            stopGetCurrentLocation()
        } else {
            //if you want clouser call again and again according to didupdate location then remove else condition.
            self.locationCompletionHandler = nil
        }
    }
    
    // MARK: - Authorization
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined: break
            // User has not yet made a choice with regards to this application
            
        case .restricted:// break
            // This application is not authorized to use location services.  Due
            // to active restrictions on location services, the user cannot change
            // this status, and may not have personally denied authorization
            Global.locationDisableAlert()
            break
            
        case .denied:// break
            // User has explicitly denied authorization for this application, or
            // location services are disabled in Settings
            Global.locationDisableAlert()
            break
            
            //For IOS 8 or Later
        case .authorizedWhenInUse, .authorizedAlways:
            // User has authorized this application to use location services
            // Request Location
            LocationTracker.shared.requestUpdating()
        }
    }
}
