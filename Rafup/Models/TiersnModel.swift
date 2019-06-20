//
//  TiersnModel.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class TiersnModel: NSObject {
    
    var name                    : String!
    var tierId                  : Int!
    var tierImage               : String!
    var descriptions            : String!
    var price                   : Double!
    var tickets                 : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        name                    = ""
        tierImage               = ""
        tierId                  = 0
        descriptions            = ""
        tickets                 = 0
        price                   = 0.0
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        tierId                  = Global.getInt(for: dictionary["Id"] ?? 0)
        name                    = dictionary["Name"] as? String ?? ""
        descriptions            = dictionary["Description"] as? String ?? ""
        tickets                 = Global.getInt(for: dictionary["Tickets"] ?? 0)
        price                   = Global.getDouble(for: dictionary["Price"] ?? 0.0)
        tierImage               = dictionary["ImagePath"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if tierId != nil {
            dictionary["Id"] = tierId
        }
        
        if name != nil {
            dictionary["Name"] = name
        }
        
        if tierImage != nil {
            dictionary["ImagePath"] = tierImage
        }
        
        
        if descriptions != nil {
            dictionary["Description"] = descriptions
        }
        
        if tickets != nil {
            dictionary["Tickets"] = tickets
        }

        
        if price != nil {
            dictionary["Price"] = price
        }
        
        return dictionary
    }

}
