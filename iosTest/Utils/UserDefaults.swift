//
//  UserDefaults.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import Foundation
import UIKit


enum UserDefaultKey: String {
    
    case userId = "UserID"
    case appKey = "AppKey"
    case lastModified = "lastModified"
    case userBalance = "userBalance"
    
}


class UserDefault : NSObject{
    
    //    var userId : Int{
    //
    //        return 1
    //    }
    
    
    //MARK:-Integer
    
    class func getIntValue(_ key : UserDefaultKey) -> Int{
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    class func saveIntValue(_ key : UserDefaultKey, value : Int){
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:-String
    class func getStringValue(_ key : UserDefaultKey) -> String?{
        return  UserDefaults.standard.value(forKey: key.rawValue) as? String
    }
    
    class func saveStringValue(_ key : UserDefaultKey, value : String){
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    class func getDouble(_ key : UserDefaultKey) -> Double{
        return UserDefaults.standard.double(forKey: key.rawValue)
    }
    
    class func saveDouble(_ key : UserDefaultKey, value : Double){
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
