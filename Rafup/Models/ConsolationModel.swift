//
//  ConsolationModel.swift
//  Rafup
//
//  Created by Ashish on 24/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ConsolationModel: NSObject {
    
    var id                     : Int!
    var name                   : String!
    var descriptions           : String!
    var point                  : Int!
    var image                  : String!
    var isRetry                = true
    var isFree                 = false
    var numberOfUsers          : Int!
    var createdDate            : String!
    var publishDate            : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        id                   = 0
        name                 = ""
        descriptions         = ""
        point                = 0
        image                = ""
        isRetry              = true
        isFree               = false
        numberOfUsers        = 0
        createdDate          = ""
        publishDate          = ""
        
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        id                  = Global.getInt(for: dictionary["Id"] ?? 0)
        name                = dictionary["Name"] as? String ?? ""
        descriptions        = dictionary["Description"] as? String ?? ""
        point               = Global.getInt(for: dictionary["Point"] ?? 0)
        image               = dictionary["ImagePath"] as? String ?? ""
        isRetry             = Global.getBoolValue(for: dictionary["IsRetry"] ?? true)
        isFree              = Global.getBoolValue(for: dictionary["IsFree"] ?? false)
        numberOfUsers       = Global.getInt(for: dictionary["NumberOfUser"] ?? 0)
        createdDate         = dictionary["CreatedDate"] as? String ?? ""
        publishDate         = dictionary["PublishDate"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if id != nil {
            dictionary["Id"] = id
        }
        
        if name != nil {
            dictionary["Name"] = name
        }
        
        if descriptions != nil {
            dictionary["Description"] = descriptions
        }
        
        if point != nil {
            dictionary["Point"] = point
        }
        
        if image != nil {
            dictionary["ImagePath"] = image
        }
        
        dictionary["IsRetry"] = isRetry
        
        dictionary["IsFree"] = isFree
        
        if numberOfUsers != nil {
            dictionary["NumberOfUser"] = numberOfUsers
        }
        
        if createdDate != nil {
            dictionary["CreatedDate"] = createdDate
        }
        
        if publishDate != nil {
            dictionary["PublishDate"] = publishDate
        }
        
        return dictionary
    }
    
}
