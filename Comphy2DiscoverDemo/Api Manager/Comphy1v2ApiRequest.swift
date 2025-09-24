//
//  ComphyServerRequest.swift
//  ImgToImgAINoCrop
//
//  Created by Bcl Dey Device 8 on 5/5/25.
//
import Foundation
import UIKit
//import Alamofire


@objc enum NCAiImageUploadStatuss: Int {
    case uploading
    case processing
    case completed
}

class Comphy1v2ApiRequest: NSObject {
    
    var task: URLSessionDataTask?
   // var uploadRequest: UploadRequest?

    public func configureURLRequest(
            urlString: String,
            apiKey: String? = nil,
            requestType: HTTPRequestType,
            headerFieldName: String = "Authorization" ,
            httpBodyParams: [String : Any]? = nil,
            queryItems: [String: Any]? = nil
        ) -> URLRequest? {
            
            guard var urlComponents = URLComponents(string: urlString) else {
                print("Invalid string to create URL from")
                return nil
            }
            
            // ✅ Attach query items before creating the URL
            if let queryItems = queryItems {
                urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
            
            // ✅ Now get the final URL
            guard let finalURL = urlComponents.url else {
                print("Failed to construct final URL with query items")
                return nil
            }
            
            var urlRequest = URLRequest(url: finalURL)
            urlRequest.httpMethod = requestType.rawValue
            urlRequest.timeoutInterval = 400.0
            
            if let apiKey = apiKey {
                //urlRequest.addValue(allDataApiKey, forHTTPHeaderField: "Authorization")
                urlRequest.addValue(apiKey, forHTTPHeaderField: headerFieldName)
                
            }
            
            // Set content type for x-www-form-urlencoded (POST, etc.)
            if let httpBodyParams = httpBodyParams {
                urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let bodyString = httpBodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
                urlRequest.httpBody = bodyString.data(using: .utf8)
            }
            
            return urlRequest
        }

    
//    func callImageToImageAPI(jsonFileURL: URL,
//                                 imageURL: URL,
//                                 statusCallback: ((NCAiImageUploadStatuss) -> Void)?,
//                                 completion: @escaping (URL?, Error?) -> Void) {
//        let imageToImageURLString = Comphy1v2APIEnvironment.base_ML_URLString + "/generate-image2image"
//            let url = URL(string: imageToImageURLString)!
//            let headers: HTTPHeaders = [
//                "Authorization": "Bearer \(Comphy1v2APIEnvironment.ml_Authorization)"
//            ]
//            
//            statusCallback?(.uploading)
//            
//            uploadRequest = AF.upload(multipartFormData: { multipartFormData in
//                // JSON File
//                if let jsonData = try? Data(contentsOf: jsonFileURL) {
//                    multipartFormData.append(jsonData, withName: "json_data", fileName: "jsonFile.json", mimeType: "application/json")
//                }
//                
//                // Image File
//                if let imageData = try? Data(contentsOf: imageURL) {
//                    multipartFormData.append(imageData, withName: "image_file", fileName: "inputImage.png", mimeType: "image/png")
//                }
//            }, to: url, method: .post, headers: headers)
//            .uploadProgress { progress in
//                print("Upload Progress: \(progress.fractionCompleted)")
//                if progress.fractionCompleted == 1.0 {
//                    statusCallback?(.processing)
//                }
//            }
//            .responseData { response in
//                switch response.result {
//                case .success(let data):
//                    print("image2image: \(String(data: data, encoding: .utf8))")
//                    statusCallback?(.completed)
//                    
//                    let tempZipURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.zip")
//                    do {
//                        try data.write(to: tempZipURL)
//                        completion(tempZipURL, nil)
//                    } catch {
//                        completion(nil, error)
//                    }
//     
//                case .failure(let error):
//                    if (error.isExplicitlyCancelledError) {
//                        print("Request was cancelled.")
//                        let ModifiedError = NSError(
//                            domain: "User Cancelled",
//                            code: NSURLErrorCancelled, // Treat like user cancel
//                            userInfo: [NSLocalizedDescriptionKey: "Request was cancelled"]
//                        )
//                        completion(nil, ModifiedError)
//                    } else {
//                        completion(nil, error)
//                    }
//                }
//            }
//        }
    
    @objc public func getAllDataComphy1v2WithCompletion(_ completion: @escaping (AllDataModelComphy1v2?, NSError?) -> Void) {
        let userInfoUrlString = Comphy1v2APIEnvironment.base_AllData_URLString
        
        let apiKEY = Comphy1v2APIEnvironment.base_AllData_ApiKey
        
        guard let request = configureURLRequest(urlString: userInfoUrlString, apiKey: apiKEY, requestType: .GET, headerFieldName: "token") else {
            let error = NSError(domain: "InvalidRequestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request configuration"])
            completion(nil, error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as NSError? {
                completion(nil, error)
                return
            }
            print("Alldata 1v2 \(String(data: data!, encoding: .utf8))")
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(nil, noDataError)
                return
            }

            do {
                
                let decoded = try JSONDecoder().decode(AllDataModelComphy1v2.self, from: data)
                saveAllDataJsonInRootDirectory(jsonData: data, fileName: AIIMAGE_COMPHY_JSON_FILE_NAME)
                if let dataContainers = decoded.data {
                    decoded.accessData = mergeComphy1v2Containers(dataContainers)
                }
                decoded.populateTagDiscoverLists()
                completion(decoded, nil)
            } catch let decodeError as NSError {
                completion(nil, decodeError)
            }
        }

        task.resume()
    }

        
//    func generateCaption(with image: UIImage, completion: @escaping (_ responseText: String?, _ error: Error?) -> Void) {
//        let urlString = Comphy1v2APIEnvironment.base_ML_URLString + "/image2caption"
//        guard let url = URL(string: urlString) else {
//            completion(nil, NSError(domain: "NCAiImageExpandPromptAPIErrorDomain", code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 400.0
//        request.setValue("Bearer \(Comphy1v2APIEnvironment.ml_Authorization)", forHTTPHeaderField: "Authorization")
//        // COMPHY2
//        //request.setValue("Bearer kepHq8UbyuU82f4ILIVYDneJp6Fm3mQI", forHTTPHeaderField: "Authorization")
//        
//        let boundary = "Boundary-Unique-Boundary-String"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            let error = NSError(domain: "NCAiImageExpandPromptAPIErrorDomain", code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to JPEG data"])
//            completion(nil, error)
//            return
//        }
//        
//        var body = Data()
//        
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"image_file\"; filename=\"inputImage.jpg\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: .utf8)!)
//        
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        request.httpBody = body
//        
//        self.task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                let error = NSError(domain: "NCAiImageExpandPromptAPIErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No HTTP response"])
//                completion(nil, error)
//                return
//            }
//            
//            guard httpResponse.statusCode == 200 else {
//                let error = NSError(domain: "NCAiImageExpandPromptAPIErrorDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Non-200 status code"])
//                completion(nil, error)
//                return
//            }
//            
//            if let data = data, let responseText = String(data: data, encoding: .utf8) {
//                completion(responseText, nil)
//            } else {
//                let error = NSError(domain: "NCAiImageExpandPromptAPIErrorDomain", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to decode response"])
//                completion(nil, error)
//            }
//        }
//        
//        task?.resume()
//    }
    
//    func callTextToImageAPI(with jsonURL: URL, completion: @escaping (URL?, Error?) -> Void) {
//        let image2imageURLString = Comphy1v2APIEnvironment.base_ML_URLString + "/generate-text2image"
//        
//        guard let jsonData = try? Data(contentsOf: jsonURL) else {
//            let error = NSError(
//                domain: "LocalFileError",
//                code: NSURLErrorCancelled, // Treat like user cancel
//                userInfo: [NSLocalizedDescriptionKey: "Failed to read JSON data from file"]
//            )
//            completion(nil, error)
//            return
//        }
//
//        guard let url = URL(string: image2imageURLString) else {
//            let error = NSError(
//                domain: "NCAiImageTextToImageAPIErrorDomain",
//                code: NSURLErrorCancelled, // Treat like user cancel
//                userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"]
//            )
//            completion(nil, error)
//            return
//        }
//
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 400.0
//        
//        let boundary = "Boundary-Unique-Boundary-String"
//        request.setValue("Bearer \(Comphy1v2APIEnvironment.ml_Authorization)", forHTTPHeaderField: "Authorization")
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        var body = Data()
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition: form-data; name=\"json_data\"; filename=\"jsonFile.json\"\r\n".data(using: .utf8)!)
//        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
//        body.append(jsonData)
//        body.append("\r\n".data(using: .utf8)!)
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        request.httpBody = body
//        
//        self.task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let self else { return }
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            print("T2I \(String(data: data!, encoding: .utf8))")
//            guard let httpResponse = response as? HTTPURLResponse else {
//                let error = NSError(domain: "NCAiImageTextToImageAPIErrorDomain", code: 502, userInfo: [
//                    NSLocalizedDescriptionKey: "Invalid response"
//                ])
//                completion(nil, error)
//                return
//            }
//            
//            guard httpResponse.statusCode == 200, let data = data else {
//                let error = NSError(domain: "NCAiImageTextToImageAPIErrorDomain", code: httpResponse.statusCode, userInfo: [
//                    NSLocalizedDescriptionKey: "Non-200 status code received"
//                ])
//                completion(nil, error)
//                return
//            }
//            
//            let tempZipURL = FileManager.default.temporaryDirectory.appendingPathComponent("comphy1v2_text2image_output.zip")
//            do {
//                try data.write(to: tempZipURL)
//                completion(tempZipURL, nil)
//            } catch {
//                // TODO: Delete the folder cretaed
//                completion(nil, error)
//                return
//            }
//        }
//        self.task?.resume()
//    }
    
    func cancelRequests() {
        print("cancel Request")

        // Cancel URLSessionTask if running
        if let task = task, task.state == .running {
            print("Cancelling data task...")
            task.cancel()
        } else {
            print("No running data task to cancel")
        }

        // Cancel Alamofire UploadRequest if resumed
//        if let uploadRequest = uploadRequest, uploadRequest.state == .resumed {
//            print("Cancelling upload request...")
//            uploadRequest.cancel()
//        } else {
//            print("No running upload request to cancel")
       // }
    }

    
    
    
    func fetchApiRequestModelFromJsonURL(from urlString: String, completion: @escaping (APIRequestModel?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            let error = NSError(domain: "URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to make URL"])
            completion(nil, error)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
               
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("No data received from: \(url)")
                let error = NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty Data Recieved"])
                completion(nil, error)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard var dictionary = json as? [String: Any] else {
                    throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected JSON dictionary"])
                }

                if let seed = dictionary["seed"], !(seed is NSNull) {
                    let seedStr = "\(seed)"
                    if seedStr.count > 18 {
                        print("Discover Seed String digit count \(seedStr.count)")
                    }
                    
                    dictionary["seedStr"] = seedStr
                    
                    if let seedNumber = seed as? NSNumber {
                        dictionary["seed"] = seedNumber.int64Value
                    } else if let seedString = seed as? String, let seedInt = Int64(seedString) {
                        dictionary["seed"] = seedInt
                    }
                }


                let cleanedData = try JSONSerialization.data(withJSONObject: dictionary, options: [])

                let decodedModel = try JSONDecoder().decode(APIRequestModel.self, from: cleanedData)
                completion(decodedModel, nil)
            } catch {
                print("ecoding error: \(error)")
                completion(nil, error)
            }
        }.resume()
    }
    
//    func callExpandPromptAPI(prompt: String, completion: @escaping (_ responseText: String?, _ error: Error?) -> Void) {
//        
//        let endpoint = Comphy1v2APIEnvironment.base_ML_URLString + "/expand-prompt"
//        
//        var components = URLComponents(string: endpoint)
//        components?.queryItems = [URLQueryItem(name: "prompt", value: prompt)]
//        
//        guard let url = components?.url else {
//            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to construct URL"]))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 400.0
//        request.setValue("Bearer \(Comphy1v2APIEnvironment.ml_Authorization)", forHTTPHeaderField: "Authorization")
//
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(nil, NSError(domain: "NoHTTPResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "No valid response received"]))
//                return
//            }
//
//            guard httpResponse.statusCode == 200 else {
//                let statusError = NSError(domain: "NCAiImageTextToTextAPIErrorDomain",
//                                          code: httpResponse.statusCode,
//                                          userInfo: [NSLocalizedDescriptionKey: "Non-200 status code received"])
//                completion(nil, statusError)
//                return
//            }
//
//            if let data = data, let responseText = String(data: data, encoding: .utf8) {
//                completion(responseText, nil)
//            } else {
//                completion(nil, NSError(domain: "EmptyResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in response"]))
//            }
//        }
//
//        task.resume()
//    }




}


enum HTTPRequestType: String {
    case GET
    case POST
    case PATCH
}
