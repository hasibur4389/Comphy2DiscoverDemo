//
//  ApiRequestModel.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import Foundation

@objcMembers
class APIRequestModel: NSObject, Codable {
    var cfg: Float?
    var instantIdData: Comphy2InstantIdData?
    var prompt: String?
    var numOfImages: Int?
    var height: Int?
    var negPrompt: String?
    var samplerName: String?
    var image: String?
    var width: Int?
    var loras: [RequestLora]?
    var modelName: String?
    var faceImg: String?
    var controlnets: [Comphy2ControlNet]?
    var denoise: Float?
    var steps: Int?
    var styleName: String?
    var seed: Int64?
    var seedStr: String?
    var refImg: String?
    var willSegment: Bool?
    var scheduler: String?
    var background: String?
    var visualOnBody: String?
    
    // New: Optional for Comphy1/Core Data compatibility
    var appVersion: String?
    var identifier: String?
    var viewType: AiImageViewType?
    var model: String?
    var model_id: String?
    var style_id: String?
    var guidanceScale: Float?
    var sampler: String?
    var sampler_id: String?
    var blockNSFW: Bool?
    var fromDiscover: Bool?
    var imageDenoise: Float?
    var inputImagePath: String?
    var outputImagePath: String?
    var creationDate: String?

    enum CodingKeys: String, CodingKey {
        case cfg
        case instantIdData = "instant_id_data"
        case prompt
        case numOfImages = "num_of_images"
        case height
        case negPrompt = "neg_prompt"
        case samplerName = "sampler_name"
        case image
        case width
        case loras
        case modelName = "model_name"
        case faceImg = "face_img"
        case controlnets
        case denoise
        case steps
        case styleName = "style_name"
        case seed
        case refImg = "ref_img"
        case willSegment = "will_segment"
        case scheduler
        case background
        case visualOnBody
        // new
        case appVersion
        case identifier
        case viewType
        case model
        case model_id
        case style_id
        case guidanceScale = "guidance_scale"
        case seedStr
        case sampler
        case sampler_id
        case blockNSFW = "block_nsfw"
        case fromDiscover
        case imageDenoise = "image_denoise"
        case inputImagePath
        case outputImagePath
        case creationDate
    }
    
    init(cfg: Float? = nil,
         instantIdData: Comphy2InstantIdData? = nil,
         prompt: String? = nil,
         numOfImages: Int? = nil,
         height: Int? = nil,
         negPrompt: String? = nil,
         samplerName: String? = nil,
         image: String? = nil,
         width: Int? = nil,
         loras: [RequestLora]? = nil,
         modelName: String? = nil,
         faceImg: String? = nil,
         controlnets: [Comphy2ControlNet]? = nil,
         visualOnBody: String? = nil,
         denoise: Float? = nil,
         steps: Int? = nil,
         styleName: String? = nil,
         seed: Int64? = nil,
         refImg: String? = nil,
         willSegment: Bool? = nil,
         scheduler: String? = nil,
         background: String? = nil,
         appVersion: String? = nil,
         identifier: String? = nil,
         viewType: AiImageViewType? = nil,
         model: String? = nil,
         model_id: String? = nil,
         style_id: String? = nil,
         guidanceScale: Float? = nil,
         seedStr: String? = nil,
         sampler: String? = nil,
         sampler_id: String? = nil,
         blockNSFW: Bool? = nil,
         fromDiscover: Bool? = nil,
         imageDenoise: Float? = nil,
         inputImagePath: String? = nil,
         outputImagePath: String? = nil,
         creationDate: String? = nil) {
        
        self.cfg = cfg
        self.instantIdData = instantIdData
        self.prompt = prompt
        self.numOfImages = numOfImages
        self.height = height
        self.negPrompt = negPrompt
        self.samplerName = samplerName
        self.image = image
        self.width = width
        self.loras = loras
        self.modelName = modelName
        self.faceImg = faceImg
        self.controlnets = controlnets
        self.denoise = denoise
        self.visualOnBody = visualOnBody
        
        self.steps = steps
        self.styleName = styleName
        self.seed = seed
        self.refImg = refImg
        self.willSegment = willSegment
        self.scheduler = scheduler
        self.background = background
        
        // New
        self.appVersion = appVersion
        self.identifier = identifier
        self.viewType = viewType
        self.model = model
        self.model_id = model_id
        self.style_id = style_id
        self.guidanceScale = guidanceScale
        self.seedStr = seedStr
        self.sampler = sampler
        self.sampler_id = sampler_id
        self.blockNSFW = blockNSFW
        self.fromDiscover = fromDiscover
        self.imageDenoise = imageDenoise
        self.inputImagePath = inputImagePath
        self.outputImagePath = outputImagePath
        self.creationDate = creationDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.cfg = try container.decodeIfPresent(Float.self, forKey: .cfg)
        self.instantIdData = try container.decodeIfPresent(Comphy2InstantIdData.self, forKey: .instantIdData)
        self.prompt = try container.decodeIfPresent(String.self, forKey: .prompt)
        self.numOfImages = try container.decodeIfPresent(Int.self, forKey: .numOfImages)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
        self.negPrompt = try container.decodeIfPresent(String.self, forKey: .negPrompt)
        self.samplerName = try container.decodeIfPresent(String.self, forKey: .samplerName)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
        self.loras = try container.decodeIfPresent([RequestLora].self, forKey: .loras)
        self.modelName = try container.decodeIfPresent(String.self, forKey: .modelName)
        self.faceImg = try container.decodeIfPresent(String.self, forKey: .faceImg)
        self.controlnets = try container.decodeIfPresent([Comphy2ControlNet].self, forKey: .controlnets)
        self.denoise = try container.decodeIfPresent(Float.self, forKey: .denoise)
        self.steps = try container.decodeIfPresent(Int.self, forKey: .steps)
        self.styleName = try container.decodeIfPresent(String.self, forKey: .styleName)
        self.seed = try container.decodeIfPresent(Int64.self, forKey: .seed)
        
        self.refImg = try container.decodeIfPresent(String.self, forKey: .refImg)
        self.willSegment = try container.decodeIfPresent(Bool.self, forKey: .willSegment)
        self.scheduler = try container.decodeIfPresent(String.self, forKey: .scheduler)
        self.background = try container.decodeIfPresent(String.self, forKey: .background)
        self.visualOnBody = try container.decodeIfPresent(String.self, forKey: .visualOnBody)
        
        self.appVersion = try container.decodeIfPresent(String.self, forKey: .appVersion)
        self.identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        
        if let viewTypeRaw = try container.decodeIfPresent(Int.self, forKey: .viewType) {
            self.viewType = AiImageViewType(rawValue: Int16(UInt32(viewTypeRaw)))
        } else {
            self.viewType = nil
        }
        
        self.model = try container.decodeIfPresent(String.self, forKey: .model)
        self.model_id = try container.decodeIfPresent(String.self, forKey: .model_id)
        self.style_id = try container.decodeIfPresent(String.self, forKey: .style_id)
        self.guidanceScale = try container.decodeIfPresent(Float.self, forKey: .guidanceScale)
        self.seedStr = try container.decodeIfPresent(String.self, forKey: .seedStr)
        self.sampler = try container.decodeIfPresent(String.self, forKey: .sampler)
        self.sampler_id = try container.decodeIfPresent(String.self, forKey: .sampler_id)
        self.blockNSFW = try container.decodeIfPresent(Bool.self, forKey: .blockNSFW)
        self.fromDiscover = try container.decodeIfPresent(Bool.self, forKey: .fromDiscover)
        self.imageDenoise = try container.decodeIfPresent(Float.self, forKey: .imageDenoise)
        self.inputImagePath = try container.decodeIfPresent(String.self, forKey: .inputImagePath)
        self.outputImagePath = try container.decodeIfPresent(String.self, forKey: .outputImagePath)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(cfg, forKey: .cfg)
        try container.encodeIfPresent(instantIdData, forKey: .instantIdData)
        try container.encodeIfPresent(prompt, forKey: .prompt)
        try container.encodeIfPresent(numOfImages, forKey: .numOfImages)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(negPrompt, forKey: .negPrompt)
        try container.encodeIfPresent(samplerName, forKey: .samplerName)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encodeIfPresent(width, forKey: .width)
        try container.encodeIfPresent(loras, forKey: .loras)
        try container.encodeIfPresent(modelName, forKey: .modelName)
        try container.encodeIfPresent(faceImg, forKey: .faceImg)
        try container.encodeIfPresent(controlnets, forKey: .controlnets)
        try container.encodeIfPresent(denoise, forKey: .denoise)
        try container.encodeIfPresent(steps, forKey: .steps)
        try container.encodeIfPresent(styleName, forKey: .styleName)
        try container.encodeIfPresent(refImg, forKey: .refImg)
        try container.encodeIfPresent(willSegment, forKey: .willSegment)
        try container.encodeIfPresent(scheduler, forKey: .scheduler)
        try container.encodeIfPresent(background, forKey: .background)
        try container.encodeIfPresent(visualOnBody, forKey: .visualOnBody)
        try container.encodeIfPresent(seed, forKey: .seed)

        
        try container.encodeIfPresent(appVersion, forKey: .appVersion)
        try container.encodeIfPresent(identifier, forKey: .identifier)
        try container.encodeIfPresent(viewType?.rawValue, forKey: .viewType)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encodeIfPresent(model_id, forKey: .model_id)
        try container.encodeIfPresent(style_id, forKey: .style_id)
        try container.encodeIfPresent(guidanceScale, forKey: .guidanceScale)
        try container.encodeIfPresent(seedStr, forKey: .seedStr)
        try container.encodeIfPresent(sampler, forKey: .sampler)
        try container.encodeIfPresent(sampler_id, forKey: .sampler_id)
        try container.encodeIfPresent(blockNSFW, forKey: .blockNSFW)
        try container.encodeIfPresent(fromDiscover, forKey: .fromDiscover)
        try container.encodeIfPresent(imageDenoise, forKey: .imageDenoise)
        try container.encodeIfPresent(inputImagePath, forKey: .inputImagePath)
        try container.encodeIfPresent(outputImagePath, forKey: .outputImagePath)
        try container.encodeIfPresent(creationDate, forKey: .creationDate)
    }
}
extension APIRequestModel {
    func deepCopyModel() -> APIRequestModel {
        let copy = APIRequestModel(
            cfg: self.cfg,
            instantIdData: self.instantIdData?.deepCopyModel(),
            prompt: self.prompt,
            numOfImages: self.numOfImages,
            height: self.height,
            negPrompt: self.negPrompt,
            samplerName: self.samplerName,
            image: self.image,
            width: self.width,
            loras: self.loras?.map { $0.deepCopyModel() },
            modelName: self.modelName,
            faceImg: self.faceImg,
            controlnets: self.controlnets?.map { $0.deepCopyModel() },
            visualOnBody: self.visualOnBody,
            denoise: self.denoise,
            steps: self.steps,
            styleName: self.styleName,
            seed: self.seed,
            refImg: self.refImg,
            willSegment: self.willSegment,
            scheduler: self.scheduler,
            background: self.background,
            appVersion: self.appVersion,
            identifier: self.identifier,
            viewType: self.viewType,
            model: self.model,
            model_id: self.model_id,
            style_id: self.style_id,
            guidanceScale: self.guidanceScale,
            seedStr: self.seedStr,
            sampler: self.sampler,
            sampler_id: self.sampler_id,
            blockNSFW: self.blockNSFW,
            fromDiscover: self.fromDiscover,
            imageDenoise: self.imageDenoise,
            inputImagePath: self.inputImagePath,
            outputImagePath: self.outputImagePath,
            creationDate: self.creationDate
        )
        return copy
    }
}


class Comphy2InstantIdData: Codable {
    var image: String?
    var imageKps: String?
    var startAt: Float?
    var endAt: Float?
    var weight: Float?

    enum CodingKeys: String, CodingKey {
        case image
        case imageKps = "image_kps"
        case startAt = "start_at"
        case endAt = "end_at"
        case weight
    }

    init(image: String? = nil,
         imageKps: String? = nil,
         startAt: Float? = nil,
         endAt: Float? = nil,
         weight: Float? = nil) {
        self.image = image
        self.imageKps = imageKps
        self.startAt = startAt
        self.endAt = endAt
        self.weight = weight
    }
    
    func deepCopyModel() -> Comphy2InstantIdData {
           return Comphy2InstantIdData(
               image: self.image,
               imageKps: self.imageKps,
               startAt: self.startAt,
               endAt: self.endAt,
               weight: self.weight
           )
       }
}

class RequestLora: Codable {
    var name: String?
    var weight: Float?
    
    // This property is for runtime use only; not part of Codable
    var isFirstLora: Bool?
    var isLoraExpanded: Bool?
    
    init(name: String? = nil, weight: Float? = nil, isFirstLora: Bool? = nil, isLoraExpanded: Bool? = nil) {
        self.name = name
        self.weight = weight
        self.isFirstLora = isFirstLora
        self.isLoraExpanded = isLoraExpanded
    }
    
    // Exclude `isFirstLora` from coding
    private enum CodingKeys: String, CodingKey {
        case name
        case weight
    }
    
    func deepCopyModel() -> RequestLora {
            return RequestLora(
                name: self.name,
                weight: self.weight,
                isFirstLora: self.isFirstLora,
                isLoraExpanded: self.isLoraExpanded
            )
        }
}

class Comphy2ControlNet: Codable {
    var startAt: Float?
    var endAt: Float?
    var weight: Float?
    var modelName: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case startAt = "start_at"
        case endAt = "end_at"
        case weight
        case modelName = "model_name"
        case image
    }

    init(startAt: Float? = nil,
         endAt: Float? = nil,
         weight: Float? = nil,
         modelName: String? = nil,
         image: String? = nil) {
        self.startAt = startAt
        self.endAt = endAt
        self.weight = weight
        self.modelName = modelName
        self.image = image
    }
    
    func deepCopyModel() -> Comphy2ControlNet {
            return Comphy2ControlNet(
                startAt: self.startAt,
                endAt: self.endAt,
                weight: self.weight,
                modelName: self.modelName,
                image: self.image
            )
        }
}
