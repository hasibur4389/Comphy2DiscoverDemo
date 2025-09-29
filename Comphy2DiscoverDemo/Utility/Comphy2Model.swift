//
//  Comphy2Model.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import Foundation

@objcMembers
class AllDataModel: NSObject, Codable {
    var models: [AiImageComphy2Model]?
    var samplers: [Comphy2Sampler]?
    var discovers: [Discover]?
    var styles: [ApiStyle]?
    var features: [ApiFeature]?
    var genres: [Genre]?
    var suggestions: [String]?
    var surprise_text: [String]?
    var tags: [Tag]?
    var app_lists: [AppList]?

    override init() {}
    
    
    //map all tags to feature
    func mapTagsToFeatures(features: [ApiFeature], tags: [Tag]) -> [ApiFeature] {
        // Create a lookup dictionary of features by _id
        var featureMap: [String: ApiFeature] = [:]
        for feature in features {
            if let id = feature._id {
                featureMap[id] = feature
            }
        }

        // Go through each tag and assign it to the correct feature(s)
        for tag in tags {
            if let featureIds = tag.features {
                for featureId in featureIds {
                    if let feature = featureMap[featureId] {
                        if feature.tagsModelArray == nil {
                            feature.tagsModelArray = []
                        }
                        feature.tagsModelArray?.append(tag)
                        featureMap[featureId] = feature // update the map with modified feature
                    }
                }
            }
        }

        // Return the updated array of features
        return Array(featureMap.values)
    }
    
    //map app styles to feature
    func mapStylesToFeatures() {
            guard let styles = self.styles, let features = self.features else { return }

            // Create a lookup dictionary for features by _id
            var featureMap: [String: ApiFeature] = [:]
            for feature in features {
                if let id = feature._id {
                    featureMap[id] = feature
                }
            }

            // Loop through styles, and for each style, map it to its features
            for style in styles {
                guard let featureIds = style.features else { continue }
                
                for featureId in featureIds {
                    if let feature = featureMap[featureId] {
                        if feature.stylesModelArray == nil {
                            feature.stylesModelArray = []
                        }
                        feature.stylesModelArray?.append(style)
                    }
                }
            }

            // Update the features array with modified features
            self.features = Array(featureMap.values)
        }

}



@objcMembers
class AiImageComphy2Model: NSObject, Codable {
    var _id: String?
    var baseModelName: String?
    var displayName: String?
    var thumbnailImageUrl: String?
    var isPro: Bool?
    var displayPosition: Int?
    var jsonKey: String?
    var createdAt: String?
    var appIds: [String]?
    var __v: Int?
    //__v

    override init() {}

    init(displayName: String?) {
        self.displayName = displayName
    }
    init(id: String?, baseModelName: String?, displayName: String?, thumbnailImageUrl: String?, isPro: Bool?, displayPosition: Int?) {
        self._id = id
        self.baseModelName = baseModelName
        self.thumbnailImageUrl = thumbnailImageUrl
        self.displayName = displayName
        self.isPro = isPro
        self.displayPosition = displayPosition
    }
}

@objcMembers
class Comphy2Sampler: NSObject, Codable {
    var _id: String?
    var samplerName: String?
    var displayName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var appIds: [String]?


    override init() {}

    init(displayName: String?) {
        self.displayName = displayName
    }
    
    init(id: String?, samplerName: String?, displayName: String?, displayPosition: Int?, isPro: Bool?) {
        self._id = id
        self.samplerName = samplerName
        self.displayName = displayName
        self.displayPosition = displayPosition
        self.isPro = isPro
        
    }
}

@objcMembers
class Discover: NSObject, Codable {
    var _id: String?
    var discoverName: String?
    var jsonKey: String?
    var isDiscoverable: Bool?
    var thumbnailImageUrl: String?
    var bannerImageUrls: [String]?
    var discoverDescription: String? // Renamed from `description` to avoid keyword conflict
    var isPro: Bool?
    var jsonFileUrl: String?
    var displayPosition: Int?
    var width: Int?
    var height: Int?
    var features: [String]?
    var genres: [String]?
    var createdAt: String?
    var __v: Int?

    enum CodingKeys: String, CodingKey {
        case _id, discoverName, jsonKey, isDiscoverable, thumbnailImageUrl, bannerImageUrls
        case discoverDescription = "description"
        case isPro, jsonFileUrl, displayPosition, width, height, features, genres, createdAt, __v
    }

    override init() {}

    init(discoverName: String?) {
        self.discoverName = discoverName
    }
}

@objcMembers
class ApiStyle: NSObject, Codable {
    var _id: String?
    var styleName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var thumbnailImageUrl: String?
    var jsonFileUrl: String?
    var displayName: String?
    var jsonKey: String?
    var features: [String]?
    var appIds: [String]?
    var createdAt: String?


    override init() {}

    init(styleName: String?, displayName: String?) {
        self.styleName = styleName
        self.displayName = displayName
    }
}

@objcMembers
class ApiFeature: NSObject, Codable {
    var _id: String?
    var name: String?
    var models: [String]?
    var samplers: [String]?
    var __v: Int?
    var appIds: [String]?
    var tagsModelArray: [Tag]? = []
    var stylesModelArray: [ApiStyle]? = []

    override init() {}

    init(name: String?) {
        self.name = name
    }
}

@objcMembers
class Genre: NSObject, Codable {
    var _id: String?
    var name: String?
    var features: [String]?
    var __v: Int?
    var appIds: [String]?


    override init() {}

    init(name: String?) {
        self.name = name
    }
}

@objcMembers
class Tag: NSObject, Codable {
    var _id: String?
    var name: String?
    var isPro: Bool?
    var displayPosition: Int?
    var status: Bool?
    var discovers: [String]?
    var __v: Int?
    var displayName: String?
    var features: [String]?
    var appIds: [String]?


    // New property
    var discoverModels: [Comphy2Discover]?
    
    override init() {}

    init(name: String?) {
        self.name = name
    }
    
    init(_id: String?) {
        self._id = _id
        self.displayName = _id
    }
    
    func mapDiscoverModels(from discoverArr: [Comphy2Discover]) {
        guard let discovers = self.discovers else { return }
        let discoverDict = Dictionary(uniqueKeysWithValues: discoverArr.compactMap { ($0._id ?? "", $0) })
        self.discoverModels = discovers.compactMap { discoverDict[$0] }
    }
}

@objcMembers
class AppList: NSObject, Codable {
    var _id: String?
    var name: String?
    var displayName: String?
    var displayPosition: Int?
    var status: Bool?
    var __v: Int?

    override init() {}

    init(name: String?, displayName: String?) {
        self.name = name
        self.displayName = displayName
    }
}

@objcMembers
class Comphy2Discover: NSObject, Codable {
   var _id: String?
   var discoverName: String?
   var jsonKey: String?
   var isDiscoverable: Bool?
   var thumbnailImageUrl: String?
   var bannerImageUrls: [String]?
   var descriptionText: String?
   var isPro: Bool?
   var jsonFileUrl: String?
   var displayPosition: Int?
   var width: Int?
   var height: Int?
   var features: [String]?
   var genres: [String]?
   var createdAt: String?
   var __v: Int?
   var appIds: [String]?
   
   override init() {}
   
   enum CodingKeys: String, CodingKey {
       case _id
       case discoverName
       case jsonKey
       case isDiscoverable
       case thumbnailImageUrl
       case bannerImageUrls
       case descriptionText = "description"
       case isPro
       case jsonFileUrl
       case displayPosition
       case width
       case height
       case features
       case genres
       case createdAt
       case __v
       case appIds
   }
}

@objcMembers
class StyleContainerComphy2: NSObject, Codable {
    var styles: [ApiStyle]
    var pagination: StyleComphy2Pagination
}

@objcMembers
class StyleComphy2Pagination: NSObject, Codable {
    var page: Int
    var limit: Int
    var total: Int
    var totalPages: Int
    var hasNext: Bool
    var hasPrev: Bool
}



@objcMembers
class TagsResponseModel: NSObject, Codable {
   var discoverArr: [Comphy2Discover]?
   var tags: [Tag]?
   
   override init() {}
    
    init(discoverArr: [Comphy2Discover]?, tagID: String?) {
        self.discoverArr = discoverArr
        let tag = Tag(_id: tagID)
        tag.discoverModels = discoverArr
        self.tags = [tag]
    }
   
   enum CodingKeys: String, CodingKey {
       case tags
       case discoverArr = "discover"
   }
   
}
