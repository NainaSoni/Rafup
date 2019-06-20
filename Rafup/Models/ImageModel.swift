//
//  ImageModel.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ImageModel: NSObject {

    var image                  : String!
    var imageId                : Int!
    var index                  : Int?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        image                    = ""
        imageId                  = 0
        index                    = 0
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        imageId                 = Global.getInt(for: dictionary["Id"] ?? 0)
        image                   = dictionary["Image"] as? String ?? ""
        index                   = Global.getInt(for: dictionary["index"] ?? 0)
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if imageId != nil {
            dictionary["Id"] = imageId
        }
        
        if image != nil {
            dictionary["Image"] = image
        }
        
        if index != nil {
            dictionary["index"] = index
        }
        
        return dictionary
    }
}
