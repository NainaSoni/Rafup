//
//  QuestionModel.swift
//  Rafup
//
//  Created by Ashish on 17/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class QuestionModel: NSObject {

    var ticketId               : Int!
    var productId              : Int!
    var categotyId             : Int!
    var questionId             : Int!
    var answer                 : String!
    var options                = [String]()
    var filePath               : String!
    var question               : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        ticketId            = 0
        productId           = 0
        categotyId          = 0
        questionId          = 0
        answer              = ""
        options             = [String]()
        filePath            = ""
        question            = ""
        
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        ticketId            = Global.getInt(for: dictionary["TickitId"] ?? 0)
        productId           = Global.getInt(for: dictionary["ProductId"] ?? 0)
        categotyId          = Global.getInt(for: dictionary["CategoryId"] ?? 0)
        questionId          = Global.getInt(for: dictionary["QuestionId"] ?? 0)
        answer              = dictionary["Answer"] as? String ?? ""
        options             = dictionary["Options"] as? [String] ?? [String]()
        filePath            = dictionary["FilePath"] as? String ?? ""
        question            = dictionary["Description"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if ticketId != nil {
            dictionary["TickitId"] = ticketId
        }
        
        if productId != nil {
            dictionary["ProductId"] = productId
        }
        
        if categotyId != nil {
            dictionary["CategoryId"] = categotyId
        }
        
        if questionId != nil {
            dictionary["QuestionId"] = questionId
        }
        
        if answer != nil {
            dictionary["Answer"] = answer
        }
        
        dictionary["Options"] = options
        
        if filePath != nil {
            dictionary["FilePath"] = filePath
        }
        
        if question != nil {
            dictionary["Description"] = question
        }
        
        return dictionary
    }
}
