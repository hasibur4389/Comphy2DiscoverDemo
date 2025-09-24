//
//  DataModel.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import Foundation

class AllDataModelComphy1v2: NSObject, Codable {
    var message: String?
    var data: [Comphy1v2DataContainer]?
    var accessData: Comphy1v2DataContainer?

//    init(message: String?, data: [Comphy1v2DataContainer]?) {
//        self.message = message
//        self.data = data
//    }
//
    override init() {
        super.init()
    }
}

extension AllDataModelComphy1v2 {
    /// Populates `discoverList` for each tag using the global discover array
    func populateTagDiscoverLists() {
        guard let discoverList = accessData?.discover else { return }
        
        // Build a lookup dictionary for quick access
        let discoverDict: [String: Comphy1v2DiscoverModel] =
            Dictionary(uniqueKeysWithValues: discoverList.compactMap { discover in
                guard let id = discover.id else { return nil }
                return (id, discover)
            })
        
        // Map each tag's discovers -> discoverList
//        accessData?.tags?.forEach { tag in
//            if let ids = tag.discovers {
//                tag.discoverList = ids.compactMap { discoverDict[$0] }
//            }
//        }
        
        accessData?.tags?.forEach { tag in
            if let tagName = tag.tagName, tagName == "Trending" {
                var trendingList: [Comphy1v2DiscoverModel] = []
                if let ids = tag.discovers {
                    trendingList = ids.compactMap { discoverDict[$0] }
                }

                let existingIds = Set(trendingList.compactMap { $0.id })
                let remaining = discoverList.filter { discover in
                    guard let id = discover.id else { return false }
                    return !existingIds.contains(id)
                }

                tag.discoverList = trendingList + remaining
            } else if let ids = tag.discovers {
                tag.discoverList = ids.compactMap { discoverDict[$0] }
            }
        }
    }
}

@objcMembers
class Comphy1v2DataContainer: NSObject, Codable {
    var prompts: [Comphy1v2PromptModel]?
    var samplers: [Comphy1v2SamplerModel]?
    var advance_options: [Comphy1v2AdvanceOptionModel]?
    var styles: [Comphy1v2StyleModel]?
    var users: [Comphy1v2UserModel]?
    var discover: [Comphy1v2DiscoverModel]?
    var version: [Comphy1v2VersionModel]?
    var lora: [Comphy1v2LoraModel]?
    var tags: [Comphy1v2TagModel]?

    override init() {
        super.init()
    }
}

@objcMembers
class Comphy1v2TagModel: NSObject, Codable {
    var _id: String?
    var tagName: String?
    var displayName: String?
    var displayPosition: Int?
    var isActive: Bool?
    var discovers: [String]?
    var createdAt: Comphy1v2CreatedAt?
    var discoverList: [Comphy1v2DiscoverModel]?

    private enum CodingKeys: String, CodingKey {
        case _id, tagName, displayName, displayPosition, isActive, discovers, createdAt
    }
    
    override init() {
        super.init()
    }
}


@objcMembers
class Comphy1v2PromptModel: NSObject, Codable {
    var id: String?
    var promptText: String?
    var promptCategory: String?
    var displayPosition: Int?
    var jsonKey: Comphy1v2JsonKey?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case promptText
        case promptCategory
        case displayPosition
        case jsonKey
        case createdAt
    }

    override init() {
        super.init()
    }

//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.id = try container.decodeIfPresent(String.self, forKey: .id)
//        self.promptText = try container.decodeIfPresent(String.self, forKey: .promptText)
//        self.promptCategory = try container.decodeIfPresent(String.self, forKey: .promptCategory)
//
//        // Robust decoding for displayPosition (Int or String)
//        if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
//            self.displayPosition = intVal
//        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
//                  let intFromStr = Int(strVal) {
//            self.displayPosition = intFromStr
//        }
//
//        self.jsonKey = try container.decodeIfPresent(Comphy1v2JsonKey.self, forKey: .jsonKey)
//        self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
//    }
}


@objcMembers
class Comphy1v2SamplerModel: NSObject, Codable {
    var id: String?
    var samplerName: String?
    var displayName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var jsonKey: Comphy1v2JsonKey?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case samplerName, displayName, displayPosition, isPro, jsonKey, createdAt
    }
    
    override init() {
        super.init()
    }
    
    
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
    
            self.id = try container.decodeIfPresent(String.self, forKey: .id)
            self.samplerName = try container.decodeIfPresent(String.self, forKey: .samplerName)
            self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    
            // Robust decoding for displayPosition (Int or String)
            if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
                self.displayPosition = intVal
            } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
                      let intFromStr = Int(strVal) {
                self.displayPosition = intFromStr
            }
            self.isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro)
    
            self.jsonKey = try container.decodeIfPresent(Comphy1v2JsonKey.self, forKey: .jsonKey)
            self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
        }
}

@objcMembers
class Comphy1v2AdvanceOptionModel: NSObject, Codable {
    var id: String?
    var baseModelName: String?
    var displayName: String?
    var thumbnailImageUrl: String?
    var isPro: Bool?
    var displayPosition: Int?
    var jsonKey: Comphy1v2JsonKey?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case baseModelName, displayName, thumbnailImageUrl, isPro, displayPosition, jsonKey, createdAt
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.baseModelName = try container.decodeIfPresent(String.self, forKey: .baseModelName)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)

        // Robust decoding for displayPosition (Int or String)
        if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
            self.displayPosition = intVal
        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
                  let intFromStr = Int(strVal) {
            self.displayPosition = intFromStr
        }
        self.isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro)
        self.thumbnailImageUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailImageUrl)
        self.jsonKey = try container.decodeIfPresent(Comphy1v2JsonKey.self, forKey: .jsonKey)
        self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
    }
}

@objcMembers
class Comphy1v2StyleModel: NSObject, Codable {
    var id: String?
    var styleName: String?
    var displayName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var thumbnailImageUrl: String?
    var jsonFileUrl: String?
    var jsonKey: Comphy1v2JsonKey?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case styleName, displayName, displayPosition, isPro, thumbnailImageUrl, jsonFileUrl, jsonKey, createdAt
    }
    init(styleName: String, displayName: String) {
        self.styleName = styleName
        self.displayName = displayName
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.styleName = try container.decodeIfPresent(String.self, forKey: .styleName)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        self.thumbnailImageUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailImageUrl)
        // Robust decoding for displayPosition (Int or String)
        if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
            self.displayPosition = intVal
        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
                  let intFromStr = Int(strVal) {
            self.displayPosition = intFromStr
        }
        self.isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro)

        self.jsonKey = try container.decodeIfPresent(Comphy1v2JsonKey.self, forKey: .jsonKey)
        self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
    }
}

@objcMembers
class Comphy1v2UserModel: NSObject, Codable {
    // Add properties if user model structure is provided
    override init() {
        super.init()
    }
}

@objcMembers
class Comphy1v2DiscoverModel: NSObject, Codable {
    var id: String?
    var discoverName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var isDiscoverable: Bool?
    var thumbnailImageUrl: String?
    var descriptionString: String?
    var positivePrompt: String?
    var negativePrompt: String?
    var jsonFileUrl: String?
    var bannerImageUrls: [String]?
    var width: Int?
    var height: Int?
    var jsonKey: Comphy1v2JsonKey?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case descriptionString = "description"
        case discoverName, displayPosition, isPro, isDiscoverable, thumbnailImageUrl, positivePrompt, negativePrompt, jsonFileUrl, bannerImageUrls, width, height, jsonKey, createdAt
    }
    
    override init() {
        super.init()
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.discoverName = try container.decodeIfPresent(String.self, forKey: .discoverName)
        self.isDiscoverable = try container.decodeIfPresent(Bool.self, forKey: .isDiscoverable)
        self.thumbnailImageUrl = try container.decodeIfPresent(String.self, forKey: .thumbnailImageUrl)
        self.descriptionString = try container.decodeIfPresent(String.self, forKey: .descriptionString)
        self.positivePrompt = try container.decodeIfPresent(String.self, forKey: .positivePrompt)
        self.negativePrompt = try container.decodeIfPresent(String.self, forKey: .negativePrompt)
        self.bannerImageUrls = try container.decodeIfPresent([String].self, forKey: .bannerImageUrls)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro)
        self.jsonFileUrl = try container.decodeIfPresent(String.self, forKey: .jsonFileUrl)
        // Robust decoding for displayPosition (Int or String)
        if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
            self.displayPosition = intVal
        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
                  let intFromStr = Int(strVal) {
            self.displayPosition = intFromStr
        }

        self.jsonKey = try container.decodeIfPresent(Comphy1v2JsonKey.self, forKey: .jsonKey)
        self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
    }
}

@objcMembers
class Comphy1v2VersionModel: NSObject, Codable {
    var id: String?
    var versionName: Int?
    var createdAt: String?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case versionName, createdAt, updatedAt
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.versionName = try container.decodeIfPresent(Int.self, forKey: .versionName)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        
    }
}

@objcMembers
class Comphy1v2LoraModel: NSObject, Codable {
    var id: String?
    var loraName: String?
    var displayName: String?
    var displayPosition: Int?
    var isPro: Bool?
    var createdAt: Comphy1v2CreatedAt?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case loraName, displayName, displayPosition, isPro, createdAt
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.loraName = try container.decodeIfPresent(String.self, forKey: .loraName)
        self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
        if let intVal = try? container.decodeIfPresent(Int.self, forKey: .displayPosition) {
            self.displayPosition = intVal
        } else if let strVal = try? container.decodeIfPresent(String.self, forKey: .displayPosition),
                  let intFromStr = Int(strVal) {
            self.displayPosition = intFromStr
        }
        self.isPro = try container.decodeIfPresent(Bool.self, forKey: .isPro)
        self.createdAt = try container.decodeIfPresent(Comphy1v2CreatedAt.self, forKey: .createdAt)
        
    }
}

@objcMembers
class Comphy1v2JsonKey: NSObject, Codable {
    var defaultKey: String?

    enum CodingKeys: String, CodingKey {
        case defaultKey = "default"
    }
    override init() {
        super.init()
    }
}

@objcMembers
class Comphy1v2CreatedAt: NSObject, Codable {
    var defaultDateString: String?

    enum CodingKeys: String, CodingKey {
        case defaultDateString = "default"
    }

    override init() {
        super.init()
    }
//
//    init(defaultDateString: String?) {
//        self.defaultDateString = defaultDateString
//    }
}
