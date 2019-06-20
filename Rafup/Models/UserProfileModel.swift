//
//    LoginModel.swift
//  Stannah
//
//  Created by Ashish on 11/05/18.
//  Copyright © 2018 Dheeraj Kumar. All rights reserved.

import Foundation


class UserProfileModel : NSObject, NSCoding {
    
    var id                  : Int!
    var email               : String!
    var address             : String!
    var username            : String!
    var userImage           : String!
    var mobileNumber        : String!
    var zipCode             : String!
    var isAdmin             : Bool!
    var isJoiningMail       : Bool!
    var isEighteenPlus      : Bool!
    var isVerified          : Bool!
    var validId             : String!
    var touserSize          : String!
    var shoeSize            : String!
    var tShirtSize          : String!
    var gender          : String!
    var length          : String!
    var points              : Int!
    var isEighteenVerified  : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    override init() {
        id                  = 0
        email               = ""
        address             = ""
        isAdmin             = false
        isJoiningMail       = false
        zipCode             = ""
        username            = ""
        userImage           = ""
        mobileNumber        = ""
        
        isEighteenPlus      = false
        isEighteenVerified  = false
        isVerified          = false
        validId             = ""
        touserSize          = ""
        shoeSize            = ""
        tShirtSize          = ""
        gender          = ""
        length          = ""
        points              = 0
    }
    
    
    init(fromDictionary dictionary: [String:Any]){
        id                  = Global.getInt(for: dictionary["Id"] ?? 0)
        email               = dictionary["Email"] as? String
        address             = dictionary["Address"] as? String
        isAdmin             = Global.getBoolValue(for: dictionary["IsAdmin"] ?? false)
        isJoiningMail       = Global.getBoolValue(for: dictionary["IsJoinmailing"] ?? false)
        zipCode             = dictionary["Zipcode"] as? String
        username            = dictionary["Name"] as? String
        userImage           = dictionary["ProfileImage"] as? String
        mobileNumber        = dictionary["Mobile"] as? String
        
        isEighteenPlus      = Global.getBoolValue(for: dictionary["IsEighteenPlus"] ?? false)
        isVerified          = Global.getBoolValue(for: dictionary["IsVerified"] ?? false)
        validId             = dictionary["IdProof"] as? String
        touserSize          = dictionary["TrouserSize"] as? String
        shoeSize            = dictionary["ShoeSize"] as? String
        tShirtSize          = dictionary["TopSize"] as? String
        gender          = dictionary["Gender"] as? String
        length          = dictionary["Length"] as? String
        points              = Global.getInt(for: dictionary["Points"] ?? false)
        
        isEighteenVerified = false
        if let eight = isEighteenPlus, let verified = self.isVerified {
            if eight && verified {
                 isEighteenVerified = true
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["Id"] = id
        }
        if address != nil{
            dictionary["Address"] = address
        }
        
        if email != nil{
            dictionary["Email"] = email
        }
        if isAdmin != nil{
            dictionary["IsAdmin"] = isAdmin
        }
        if isJoiningMail != nil{
            dictionary["IsJoinmailing"] = isJoiningMail
        }
        if zipCode != nil{
            dictionary["Zipcode"] = zipCode
        }
        if username != nil{
            dictionary["Name"] = username
        }
        if userImage != nil{
            dictionary["ProfileImage"] = userImage
        }
        if mobileNumber != nil{
            dictionary["Mobile"] = mobileNumber
        }
        
        if isEighteenPlus != nil{
            dictionary["EighteenPlus"] = isEighteenPlus
        }
        if isVerified != nil{
            dictionary["Mobile"] = isVerified
        }
        if validId != nil{
            dictionary["IsVerified"] = validId
        }
        if touserSize != nil{
            dictionary["TrouserSize"] = touserSize
        }
        if shoeSize != nil{
            dictionary["ShoeSize"] = shoeSize
        }
        if tShirtSize != nil{
            dictionary["TopSize"] = tShirtSize
        }
        if gender != nil{
            dictionary["Gender"] = gender
        }
        if length != nil{
            dictionary["Length"] = length
        }
        if points != nil{
            dictionary["Points"] = points
        }
        if isEighteenVerified != nil{
            dictionary["isEighteenVerified"] = isEighteenVerified
        }
        
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id                 = aDecoder.decodeObject(forKey: "Id") as? Int
        email              = aDecoder.decodeObject(forKey: "Email") as? String
        address            = aDecoder.decodeObject(forKey: "Address") as? String
        isAdmin            = aDecoder.decodeObject(forKey: "IsAdmin") as? Bool
        zipCode            = aDecoder.decodeObject(forKey: "Zipcode") as? String
        username           = aDecoder.decodeObject(forKey: "Name") as? String
        userImage          = aDecoder.decodeObject(forKey: "ProfileImage") as? String
        mobileNumber       = aDecoder.decodeObject(forKey: "Mobile") as? String
        isJoiningMail      = aDecoder.decodeObject(forKey: "IsJoinmailing") as? Bool

        isEighteenPlus     = aDecoder.decodeObject(forKey: "EighteenPlus") as? Bool
        isVerified         = aDecoder.decodeObject(forKey: "IsVerified") as? Bool
        validId            = aDecoder.decodeObject(forKey: "ValidId") as? String
        touserSize         = aDecoder.decodeObject(forKey: "TrouserSize") as? String
        shoeSize           = aDecoder.decodeObject(forKey: "ShoeSize") as? String
        tShirtSize         = aDecoder.decodeObject(forKey: "TopSize") as? String
        gender         = aDecoder.decodeObject(forKey: "Gender") as? String
        length         = aDecoder.decodeObject(forKey: "Length") as? String
        points             = aDecoder.decodeObject(forKey: "Points") as? Int
        
        isEighteenVerified = aDecoder.decodeObject(forKey: "isEighteenVerified") as? Bool
        
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "Id")
        }
        
        if email != nil{
            aCoder.encode(email, forKey: "Email")
        }
        
        if address != nil{
            aCoder.encode(address, forKey: "Address")
        }
        
        if isAdmin != nil{
            aCoder.encode(isAdmin, forKey: "IsAdmin")
        }
        
        if isJoiningMail != nil{
            aCoder.encode(isJoiningMail, forKey: "IsJoinmailing")
        }
        
        if zipCode != nil{
            aCoder.encode(zipCode, forKey: "Zipcode")
        }
        
        if username != nil{
            aCoder.encode(username, forKey: "Name")
        }
        
        if userImage != nil{
            aCoder.encode(userImage, forKey: "ProfileImage")
        }
        
        if mobileNumber != nil{
            aCoder.encode(mobileNumber, forKey: "Mobile")
        }
        if isEighteenPlus != nil{
            aCoder.encode(isEighteenPlus, forKey: "EighteenPlus")
        }
        
        if isVerified != nil{
            aCoder.encode(isVerified, forKey: "IsVerified")
        }
        
        if validId != nil{
            aCoder.encode(validId, forKey: "ValidId")
        }
        
        if touserSize != nil{
            aCoder.encode(touserSize, forKey: "TrouserSize")
        }
        
        if shoeSize != nil{
            aCoder.encode(shoeSize, forKey: "ShoeSize")
        }
        
        if tShirtSize != nil{
            aCoder.encode(tShirtSize, forKey: "TopSize")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "Gender")
        }
        if length != nil{
            aCoder.encode(length, forKey: "Length")
        }
        
        if points != nil{
            aCoder.encode(points, forKey: "Points")
        }
        
        if isEighteenVerified != nil{
            aCoder.encode(isEighteenVerified, forKey: "isEighteenVerified")
        }
    }
    
    // MARK: - Update And Save User Model
    func updateUserAndSave(attributes: [String: Any]) {
        
        let newValues = attributes
        var oldValues = self.toDictionary()
        
        for (theKey, theValue) in newValues {
            oldValues[theKey] = theValue
        }
        
        let dict = UserProfileModel.init(fromDictionary: oldValues)
        dict.saveUpdatedUser(user: dict)
    }
    
    // MARK: - Get user id from User Model
    static func getUserID() -> Int {
        return UserProfileModel.getUserLogin()?.id ?? 0
    }

    // MARK: - Fetch and Save User
    func saveUser() {
        let data  = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: Constants.kAppDisplayName+"user")
        UserDefaults.standard.synchronize()
    }
    
    func saveUpdatedUser(user:UserProfileModel) {
        let data  = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(data, forKey: Constants.kAppDisplayName+"user")
        UserDefaults.standard.synchronize()
    }
    
    static func getUserLogin() -> UserProfileModel? {
        if let data = UserDefaults.standard.object(forKey: Constants.kAppDisplayName+"user") as? Data {
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            return unarc.decodeObject(forKey: "root") as? UserProfileModel
        } else {
            return nil
        }
    }
}
