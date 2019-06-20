//
//  ProductModel.swift
//  Rafup
//
//  Created by Ashish on 13/09/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

class ProductModel: NSObject {

    var ticketId                : Int!
    var tierId                  : Int!
    var quizId                  : Int!
    var productId               : Int!
    var productName             : String!
    var ticketPrice             : Double!
    var retailPrice             : Double!
    var brand                   : String!
    var size                    : String!
    var totalTickets            : Int!
    var availableTickets        : Int!
    var descriptions            : String!
    var tierName                : String!
    var tierPrice               : Double!
    var images                  = [ImageModel]()
    var totalParticepent        : Double!
    
    var resultStatus            : String!
    var winnerName              : String!
    var name                    : String!
    var email                   : String!
    var mobileNumber            : String!
    var raffleDrawnDate         : String!
    var raffleCreationDate      : String!
    
    var isEighteenPlus          : Bool!
    var isFeatured              : Bool!
    var isAnswered              : Bool!
    var isPurchased             : Bool!
    var ticketExpiryDate        : String!
    var consolation_Point       : Int!
    var consolationType         : String!
    var ticketName              : String!
    var promoCode               : String!
    var productType             : String!
    var gender                  : String!
    var length                  : String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        
        tierId                  = 0
        quizId                  = 0
        ticketId                = 0
        productId               = 0
        productName             = ""
        ticketPrice             = 0.0
        retailPrice             = 0.0
        brand                   = ""
        size                    = ""
        totalTickets            = 0
        availableTickets        = 0
        descriptions            = ""
        tierName                = ""
        tierPrice               = 0.0
        images                  = [ImageModel]()
        totalParticepent        = 0.0
        
        resultStatus            = ""
        winnerName              = ""
        name                    = ""
        email                   = ""
        mobileNumber            = ""
        raffleDrawnDate         = ""
        raffleCreationDate      = ""
        ticketExpiryDate        = ""
        isEighteenPlus         = false
        isFeatured             = false
        isAnswered             = false
        isPurchased            = false
        consolation_Point               = 0
        consolationType        = ""
        ticketName             = ""
        promoCode              = ""
        productType            = ""
        gender                 = ""
        length                 = ""
    }
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        ticketId                = Global.getInt(for: dictionary["TicketId"] ?? 0)
        tierId                  = Global.getInt(for: dictionary["TierId"] ?? 0)
        quizId                  = Global.getInt(for: dictionary["QuizId"] ?? 0)
        productId               = Global.getInt(for: dictionary["ProductId"] ?? 0)
        productName             = dictionary["ProductName"] as? String ?? ""
        ticketPrice             = Global.getDouble(for: dictionary["TicketPrice"] ?? 0.0)
        retailPrice             = Global.getDouble(for: dictionary["RetailPrice"] ?? 0.0)
        brand                   = dictionary["Brand"] as? String ?? ""
        size                    = dictionary["Size"] as? String ?? ""
        totalTickets            = Global.getInt(for: dictionary["TotalTicket"] ?? 0)
        availableTickets        = Global.getInt(for: dictionary["AvailableTickit"] ?? 0)
        tierName                = dictionary["TierName"] as? String ?? ""
        ticketExpiryDate        = dictionary["TicketExpiryDate"] as? String ?? ""
        tierPrice             = Global.getDouble(for: dictionary["TierPrice"] ?? 0.0)
        descriptions            = dictionary["Description"] as? String ?? ""
        if let imagess = dictionary["Images"] as? [[String:Any]] {
            for items in imagess {
                images.append(ImageModel.init(fromDictionary: items))
            }
        }
        totalParticepent        = Global.getDouble(for: dictionary["TotalParticepent"] ?? 0.0)
        
        resultStatus            = dictionary["Status"] as? String ?? ""
        winnerName              = dictionary["Status"] as? String ?? ""
        name                    = dictionary["Name"] as? String ?? ""
        email                   = dictionary["Email"] as? String ?? ""
        mobileNumber            = dictionary["Mobile"] as? String ?? ""
        raffleDrawnDate         = dictionary["RaffleDrawnDate"] as? String ?? ""
        raffleCreationDate      = dictionary["Created"] as? String ?? ""
        consolationType           = dictionary["ConsolationType"] as? String ?? ""
        
        isEighteenPlus         = Global.getBoolValue(for: dictionary["IsEighteenPlus"] ?? false)
        isFeatured             = Global.getBoolValue(for: dictionary["IsFeatures"] ?? false)
        isAnswered             = Global.getBoolValue(for: dictionary["IsAnswered"] ?? false)
        isPurchased            = Global.getBoolValue(for: dictionary["IsPurchased"] ?? false)
        consolation_Point         = Global.getInt(for: dictionary["Consolation_Point"] ?? 0)
        ticketName         = dictionary["TicketName"] as? String ?? ""
        promoCode         = dictionary["PromoCode"] as? String ?? ""
        productType         = dictionary["ProductType"] as? String ?? ""
        gender             = dictionary["Gender"] as? String ?? ""
        length            = dictionary["Length"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        
        var dictionary = [String:Any]()
        
        if ticketId != nil {
            dictionary["TicketId"] = ticketId
        }
        
        if tierId != nil {
            dictionary["TierId"] = tierId
        }
        
        if quizId != nil {
            dictionary["QuizId"] = quizId
        }
        
        if productId != nil {
            dictionary["ProductId"] = productId
        }
        
        if tierName != nil {
            dictionary["TierName"] = tierName
        }
        
        if tierPrice != nil {
            dictionary["TierPrice"] = tierPrice
        }
        
        if productName != nil {
            dictionary["ProductName"] = productName
        }
        
        if ticketPrice != nil {
            dictionary["TicketPrice"] = ticketPrice
        }
        
        if retailPrice != nil {
            dictionary["RetailPrice"] = retailPrice
        }
        
        if brand != nil {
            dictionary["Brand"] = brand
        }
        
        if size != nil {
            dictionary["Size"] = size
        }
        
        if totalTickets != nil {
            dictionary["TotalTicket"] = totalTickets
        }
        
        if availableTickets != nil {
            dictionary["AvailableTickit"] = availableTickets
        }
        
        if descriptions != nil {
            dictionary["Description"] = descriptions
        }
        
        if totalParticepent != nil {
            dictionary["TotalParticepent"] = totalParticepent
        }
        
        if resultStatus != nil {
            dictionary["Status"] = resultStatus
        }
        
        if winnerName != nil {
            dictionary["Status"] = winnerName
        }
        
        if name != nil {
            dictionary["Name"] = name
        }
        
        if email != nil {
            dictionary["Email"] = email
        }
        
        if mobileNumber != nil {
            dictionary["Mobile"] = mobileNumber
        }
        
        if raffleDrawnDate != nil {
            dictionary["RaffleDrawnDate"] = raffleDrawnDate
        }
        
        if raffleCreationDate != nil {
            dictionary["Created"] = raffleCreationDate
        }
        
        if ticketExpiryDate != nil {
            dictionary["TicketExpiryDate"] = ticketExpiryDate
        }
        
        
        if isPurchased != nil {
            dictionary["IsPurchased"] = isPurchased
        }
        
        if isEighteenPlus != nil {
            dictionary["IsEighteenPlus"] = isEighteenPlus
        }
        
        if isFeatured != nil {
            dictionary["IsFeatures"] = isFeatured
        }
        
        if isAnswered != nil {
            dictionary["IsAnswered"] = isAnswered
        }
        
        if consolation_Point != nil {
            dictionary["Consolation_Point"] = consolation_Point
        }
        
        if consolationType != nil {
            dictionary["ConsolationType"] = consolationType
        }
        
        if ticketName != nil {
            dictionary["TicketName"] = ticketName
        }
        if promoCode != nil {
            dictionary["PromoCode"] = promoCode
        }
        if productType != nil {
            dictionary["ProductType"] = productType
        }
        if gender != nil {
            dictionary["gender"] = gender
        }
        if length != nil {
            dictionary["length"] = length
        }
        return dictionary
    }
}
