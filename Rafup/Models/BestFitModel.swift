//
//  BestFitModel.swift
//  Rafup
//
//  Created by Ashish on 10/10/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

enum BestFit {
    case bestFit
    case bestShoe
    case feartured
}

class BestFitModel: NSObject {

    var id               : Int!
    var instagramId      : Int!
    var height           : Double!
    var width            : Double!
    var displayUrl       : String!
    var ownerId          : Int!
    var thumb            : String!
    var shortCode        : String!
    var createdAt        : String!
    var type             : BestFit!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        id               = 0
        instagramId      = 0
        height           = 0.0
        width            = 0.0
        displayUrl       = ""
        ownerId          = 0
        thumb            = ""
        shortCode        = ""
        createdAt        = ""
        type             = .bestFit
        
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {

        id               = Global.getInt(for: dictionary["id"] ?? 0)
        instagramId      = Global.getInt(for: dictionary["InstagramId"] ?? 0)
        height           = Global.getDouble(for: dictionary["height"] ?? 0.0)
        width            = Global.getDouble(for: dictionary["width"] ?? 0.0)
        displayUrl       = dictionary["DisplayUrl"] as? String ?? ""
        ownerId          = Global.getInt(for: dictionary["OwnerId"] ?? 0)
        thumb            = dictionary["ThumbnailSrc"] as? String ?? ""
        shortCode        = dictionary["ShortCode"] as? String ?? ""
        createdAt        = dictionary["CreatedAt"] as? String ?? ""
        
        type             = .bestFit
        if let types = dictionary["Type"] as? String {
            if types == "BestFit" {
                type  = .bestFit
            } else if types == "ShoeFit" {
                type  = .bestShoe
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if id != nil {
            dictionary["id"] = id
        }
        
        if instagramId != nil {
            dictionary["InstagramId"] = instagramId
        }
        
        if height != nil {
            dictionary["height"] = height
        }
        
        if width != nil {
            dictionary["width"] = width
        }
        
        if displayUrl != nil {
            dictionary["DisplayUrl"] = displayUrl
        }
        
        if ownerId != nil {
            dictionary["OwnerId"] = ownerId
        }
        
        if thumb != nil {
            dictionary["ThumbnailSrc"] = thumb
        }
        
        if shortCode != nil {
            dictionary["ShortCode"] = shortCode
        }
        
        if createdAt != nil {
            dictionary["CreatedAt"] = createdAt
        }
        
        if type == .bestFit {
            dictionary["Type"] = "BestFit"
        } else if type == .bestShoe {
            dictionary["Type"] = "ShoeFit"
        } else {
            dictionary["Type"] = "Featured"
        }
        
        return dictionary
    }
}
