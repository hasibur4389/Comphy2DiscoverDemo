//
//  Extras+Constant.swift
//  Comphy2DiscoverDemo
//
//  Created by Bcl Dey Device 8 on 24/9/25.
//

import Foundation
import UIKit
import SVProgressHUD

let applicationID = "68778aa081d2f0010365558f" // No crop
let AIIMAGE_COMPHY2_JSON_FILE_NAME = "comphy2APIResponse.json"
let AIIMAGE_COMPHY_JSON_FILE_NAME = "comphyAPIResponse.json"
let NC_AI_GENERATE_ROOT_DIR_NAME = "AiGenerate"


@objcMembers
class Comphy1v2APIEnvironment: NSObject {
    #if DEBUG
    static let environment = "DEBUG Comphy1v2 Api Environment"
    // AllData
    static let base_AllData_URLString = "http://comphy1v2.interlinkapi.com/app-data"
    static let base_AllData_ApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkFidSBIYWlkZXIgU2lkZGlxIiwia5MDIyfQNTE2MjM5MDIyfQ.Kl2PTFl79AMn8EjbmibWAk0-jmotW0M3nWNadU0kYUlvuw"
    // ML
    static let base_ML_URLString = "http://comphy1v2-ml.interlinkapi.com/api"
    static let ml_Authorization = "kepHq8UbyuU82f4ILIVYDneJp6Fm3mQI"
    #else
    static let environment = "PRODUCTION Comphy1v2 Api Environment"
    // AllData
    static let base_AllData_URLString = "http://comphy1v2.interlinkapi.com/app-data"
    static let base_AllData_ApiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkFidSBIYWlkZXIgU2lkZGlxIiwia5MDIyfQNTE2MjM5MDIyfQ.Kl2PTFl79AMn8EjbmibWAk0-jmotW0M3nWNadU0kYUlvuw"
    // ML
    static let base_ML_URLString = "http://comphy1v2-ml.interlinkapi.com/api"
    static let ml_Authorization = "kepHq8UbyuU82f4ILIVYDneJp6Fm3mQI"
    #endif
}


// MARK: - Comphy2 Environment
@objcMembers
class Comphy2APIEnvironment: NSObject {
    #if DEBUG
    static let environment = "DEBUG Comphy2 Api Environment"
    // All Data
    static let base_AllData_URLString = "http://comphy2-api.interlinkapi.com/api/mobile"
    static let base_AllData_ApiKey = "dhfofh4564rfdl@fef@iK343G"
    // ML
    static let base_ML_URLString = "http://103.196.86.90:19252"
    static let ml_Authorization = "kepHq8UbyuU82f4ILIVYDneJp6Fm3mQI"
    #else
    static let environment = "PRODUCTION Comphy2 Api Environment"
    // All Data
    static let base_AllData_URLString = "http://comphy2-api.interlinkapi.com/api/mobile"
    static let base_AllData_ApiKey = "dhfofh4564rfdl@fef@iK343G"
    // ML
    static let base_ML_URLString = ""
    static let ml_Authorization = ""
    #endif
}

func saveAllDataJsonInRootDirectory(jsonData: Data, fileName: String) {
    do {
        // 1. Parse the JSON
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])

        // 2. Convert it back to Data for writing
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])

        // 3. Get the Documents directory
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        // 4. Append ROOT directory path
        let aiGenerateDirectory = documentsDirectory.appendingPathComponent(NC_AI_GENERATE_ROOT_DIR_NAME)

        // 5. Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: aiGenerateDirectory.path) {
            try FileManager.default.createDirectory(at: aiGenerateDirectory, withIntermediateDirectories: true, attributes: nil)
        }

        // 6. Set file path (e.g., "result.json")
        let fileURL = aiGenerateDirectory.appendingPathComponent(fileName)

        // 7. Write JSON data to the file
        try jsonData.write(to: fileURL, options: .atomic)

        print("\(fileName) JSON saved successfully at: \(fileURL.path)")
    } catch {
        print("Error saving JSON: \(error)")
    }

}

func mergeComphy1v2Containers(_ containers: [Comphy1v2DataContainer]) -> Comphy1v2DataContainer {
    let merged = Comphy1v2DataContainer()

    for container in containers {
        if let prompts = container.prompts {
            merged.prompts = prompts
        }
        if let samplers = container.samplers {
            merged.samplers = samplers
        }
        if let advanceOptions = container.advance_options {
            merged.advance_options = advanceOptions
        }
        if let styles = container.styles {
            merged.styles = styles
        }
        if let users = container.users {
            merged.users = users
        }
        if let discover = container.discover {
            merged.discover = discover
        }
        if let version = container.version {
            merged.version = version
        }
        if let lora = container.lora {
            merged.lora = lora
        }
        if let tags = container.tags {
            merged.tags = tags
        }
    }

    return merged
}



@objc enum AiImageViewType: Int16 {
    case TextToImage
    case ImageToImage
    case ImageToCaption
    case OpenPose
    case ScribbleMagic
    case PetAvatar
    case FaceToLogo
    case TextToLogo
    case FaceToSticker
    case TextToSticker
    case TattoDesgin
    case TattoInBody
    case TShirtDesign
    case BananaEffect
}

extension UIViewController {
    func showAlert(title: String,
                   message: String,
                   buttonTitle: String = "Dismiss") {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoader(withMessage: String? = nil) {
        DispatchQueue.main.async {
            if withMessage == nil {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.show(withStatus: withMessage)
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
