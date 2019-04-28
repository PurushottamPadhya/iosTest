//
//  Api.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import Foundation
import Alamofire


struct API{
    static let base_url = "http://www.splashbase.co/api/v1"
}

protocol EndPoint{
    var path: String { get }
    var url: String { get }
}

enum EndPoints{
    
    case listingAPI
    case searchAPI
    case detailAPI(Int)
}

extension EndPoints: EndPoint{
    var path: String {
        switch self{
        case .listingAPI:                      return "/images/latest"
        case .searchAPI:                       return "/images/search"
        case .detailAPI(let id):               return "/images/" + String(id)
            
        }
    }
    
    var url: String {
        return "\(API.base_url)\(path)"
    }
}

