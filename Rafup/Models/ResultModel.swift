//
//  ResultModel.swift
//  Rafup
//
//  Created by Ashish on 20/08/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit

class ResultModel: NSObject {
    
    var productId           : Int!
    var name                : String!
    var result              : String!
    var descriptions        : String!
    var brand               : String!
    var sizes               : String!
    var image               : String!
    var retailPrice         : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        productId               = 0
        result                  = ""
        name                    = ""
        descriptions            = ""
        brand                   = ""
        sizes                   = ""
        image                   = ""
        retailPrice             = 0
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        productId               = Global.getInt(for: dictionary["ProductId"] ?? 0)
        name                    = dictionary["ProductName"] as? String ?? ""
        result                  = dictionary["Result"] as? String ?? ""
        descriptions            = dictionary["Description"] as? String ?? ""
        brand                   = dictionary["Brand"] as? String ?? ""
        sizes                   = Global.getStringValue(for: dictionary["Size"] ?? "")
        image                    = dictionary["Image"] as? String ?? ""
        retailPrice             = Global.getInt(for: dictionary["RetailPrice"] ?? 0)
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        

        if productId != nil {
            dictionary["ProductId"] = productId
        }
        
        if name != nil {
            dictionary["ProductName"] = name
        }
        
        if result != nil {
            dictionary["Result"] = result
        }
        
        if descriptions != nil {
            dictionary["Description"] = descriptions
        }
        
        if brand != nil {
            dictionary["Brand"] = brand
        }
        
        if sizes != nil {
            dictionary["Size"] = sizes
        }
        
        if image != nil {
            dictionary["Image"] = image
        }
        
        if retailPrice != nil {
            dictionary["RetailPrice"] = retailPrice
        }
        
        return dictionary
    }
}
