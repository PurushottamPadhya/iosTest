//
//  ListResponseModel.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import Foundation
import ObjectMapper

struct ListResponseModel: Codable {

    let images : [ItemResponseModel]?
    
    enum CodingKeys: String, CodingKey {
        case images
    }
}

struct ItemResponseModel: Codable {
    let url, largeUrl: String?
    let id, sourceId: Int?
    var isVideo :Bool{
        if let _ = sourceId, largeUrl?.contains(".mp4") ?? false{
            return true
        }
        return false
    }

    enum CodingKeys: String, CodingKey {
        case id
        case sourceId = "source_id"
        case url
        case largeUrl = "large_url"
    }
}







class ImageVideosListModel: Mappable {
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return self.init(map : map)
    }

    var images: [ImageVideosDetailModel]?


    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        images <- map["images"]

    }
    
}


class ImageVideosDetailModel: Mappable {
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return self.init(map : map)
    }
    

    var id: Int?
    var url: String?
    var largeUrl: String?
    var sourceId: Int?
    var isVideo = false
    
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        largeUrl  <- map["large_url"]
        sourceId <- map["source_id"]
        if let _ = sourceId{
            isVideo = true
        }
    }
    
}
