//
//  ProductDetail.swift
//  Rafup
//
//  Created by Ashish on 15/08/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit

class ProductDetail: NSObject {

    var quizId              : Int!
    var productId           : Int!
    var name                : String!
    var descriptions        : String!
    var ticketPrice         : Int!
    var qrCodeImageUrl      : String!
    var drawnDate           : String!
    var brand               : String!
    var sizes               : String!
    var images              : [String]!
    var retailPrice         : Int!
    var totalTicket         : Int!
    var remainTicket        : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        quizId                  = 0
        productId               = 0
        name                    = ""
        descriptions            = ""
        ticketPrice             = 0
        qrCodeImageUrl          = ""
        drawnDate               = ""
        brand                   = ""
        sizes                   = ""
        images                  = [String]()
        retailPrice             = 0
        totalTicket             = 0
        remainTicket            = 0
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {

        quizId                  = Global.getInt(for: dictionary["QuizId"] ?? 0)
        productId               = Global.getInt(for: dictionary["ProductId"] ?? 0)
        name                    = dictionary["ProductName"] as? String ?? ""
        descriptions            = dictionary["Description"] as? String ?? ""
        ticketPrice             = Global.getInt(for: dictionary["TicketPrice"] ?? 0)
        qrCodeImageUrl          = dictionary["QrCodeImage"] as? String ?? ""
        drawnDate               = dictionary["DrawnDate"] as? String ?? ""
        brand                   = dictionary["Brand"] as? String ?? ""
        sizes                   = Global.getStringValue(for: dictionary["Size"] ?? "")
        images                  = dictionary["Images"] as? [String] ?? [String]()
        retailPrice             = Global.getInt(for: dictionary["RetailPrice"] ?? 0)
        totalTicket             = Global.getInt(for: dictionary["TotalTicket"] ?? 0)
        remainTicket            = Global.getInt(for: dictionary["AvailableTickit"] ?? 0)
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if quizId != nil {
            dictionary["QuizId"] = quizId
        }
        
        if productId != nil {
            dictionary["ProductId"] = productId
        }
        
        if name != nil {
            dictionary["ProductName"] = name
        }
        
        if descriptions != nil {
            dictionary["Description"] = descriptions
        }
        
        if ticketPrice != nil {
            dictionary["TicketPrice"] = ticketPrice
        }
        
        if qrCodeImageUrl != nil {
            dictionary["QrCodeImage"] = qrCodeImageUrl
        }
        
        if drawnDate != nil {
            dictionary["DrawnDate"] = drawnDate
        }
        
        
        if brand != nil {
            dictionary["Brand"] = brand
        }
        
        if sizes != nil {
            dictionary["Size"] = sizes
        }
        
        if images != nil {
            dictionary["Images"] = images
        }
        
        if retailPrice != nil {
            dictionary["RetailPrice"] = retailPrice
        }
        
        if totalTicket != nil {
            dictionary["TotalTicket"] = totalTicket
        }
        
        if remainTicket != nil {
            dictionary["AvailableTickit"] = remainTicket
        }
        
        return dictionary
    }
}
