//
//  User.swift
//  LoadMore
//
//  Created by Ayyanchira, Akshay Murari on 11/30/17.
//  Copyright © 2017 group2. All rights reserved.
//

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User {
    public var id : Int?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var gender : String?
    public var ip_address : String?
    
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let User_list = User.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of User Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let User = User(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: User Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        gender = dictionary["gender"] as? String
        ip_address = dictionary["ip_address"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.first_name, forKey: "first_name")
        dictionary.setValue(self.last_name, forKey: "last_name")
        dictionary.setValue(self.email, forKey: "email")
        dictionary.setValue(self.gender, forKey: "gender")
        dictionary.setValue(self.ip_address, forKey: "ip_address")
        
        return dictionary
    }
    
}

