//
//  Comphy2ApiRequest.swift
//  NoCrop
//
//  Created by Bcl Dey Device 8 on 20/7/25.
//

import Foundation
import UIKit
//import Alamofire

@objcMembers
class Comphy2ApiRequest: NSObject {
    var allDatabaseUrl = Comphy2APIEnvironment.base_AllData_URLString
    var apiKey = Comphy2APIEnvironment.base_AllData_ApiKey
    var mlBaseUrl = Comphy2APIEnvironment.base_ML_URLString
    var mlAuthorization = Comphy2APIEnvironment.ml_Authorization
    var task: URLSessionDataTask?
    //var uploadRequest: UploadRequest?
  
   
    
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
            
            //  Attach query items before creating the URL
            if let queryItems = queryItems {
                urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            }
            
            //  Now get the final URL
            guard let finalURL = urlComponents.url else {
                print("Failed to construct final URL with query items")
                return nil
            }
            
            var urlRequest = URLRequest(url: finalURL)
            urlRequest.httpMethod = requestType.rawValue
            urlRequest.timeoutInterval = 30
            
            if let apiKey = apiKey {
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
    
    
    public func fetchRawJSONDictionary(request: URLRequest) async throws -> [[String: Any]] {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }
        
        if data.isEmpty {
            throw NSError(domain: "EmptyData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Received empty data"])
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = json as? [[String: Any]] else {
                throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected JSON dictionary"])
            }
            return dictionary
        } catch {
            throw NSError(domain: "JSONParsing", code: 0, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
        }
    }
    
//    public func fetchRawJSONOfList(request: URLRequest) async throws -> [String: Any] {
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//            throw NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
//        }
//        
//        if data.isEmpty {
//            throw NSError(domain: "EmptyData", code: 0, userInfo: [NSLocalizedDescriptionKey: "Received empty data"])
//        }
//        
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: [])
//            guard let dictionary = json as? [String: Any] else {
//                throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected JSON dictionary"])
//            }
//            return dictionary
//        } catch {
//            throw NSError(domain: "JSONParsing", code: 0, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
//        }
//    }

//    func generateComphy2(jsonURL: URL,
//                         statusCallback: ((NCAiImageUploadStatuss) -> Void)?,
//                         completion: @escaping (URL?, Error?) -> Void) {
//      
//        let urlString = mlBaseUrl + "/generate"
//        guard let url = URL(string: urlString) else {
//            let error = NSError(domain: "InvalidURLError", code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//            completion(nil, error)
//            return
//        }
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(mlAuthorization)"
//        ]
//        
//        statusCallback?(.uploading)
//        
//        uploadRequest = AF.upload(multipartFormData: { multipartFormData in
//            if let jsonData = try? Data(contentsOf: jsonURL) {
//                multipartFormData.append(jsonData, withName: "json_data", fileName: "input.json", mimeType: "application/json")
//            }
//        }, to: url, method: .post, headers: headers)
//        .uploadProgress { progress in
//            print("Upload Progress: \(progress.fractionCompleted)")
//            if progress.fractionCompleted == 1.0 {
//                statusCallback?(.processing)
//            }
//        }
//        .responseData { response in
//            switch response.result {
//            case .success(let data):
//                print("comph2 data: \(String(data: data, encoding: .utf8))")
//                statusCallback?(.completed)
//                let tempZipURL = FileManager.default.temporaryDirectory.appendingPathComponent("comphy2_output.zip")
//                do {
//                    try data.write(to: tempZipURL)
//                    completion(tempZipURL, nil)
//                } catch {
//                    completion(nil, error)
//                }
//                
//            case .failure(let error):
//                if error.isExplicitlyCancelledError {
//                    print("Comphy2 Request was cancelled.")
//                }
//                completion(nil, error)
//            }
//        }
//    }
    
    func getAppList() {
        let appListUrl = allDatabaseUrl + "/app-lists"
        guard let urlRequest = configureURLRequest(urlString: appListUrl, apiKey: self.apiKey, requestType: .GET, headerFieldName: "api-key") else {
            print("COMPHY2: ##InvalidRequestError")
            return
        }
        
        Task {
            do {
                let json = try await fetchRawJSONDictionary(request: urlRequest)
                print("COMPHY2: ##Success getting AppList")
            }
            catch {
                print("COMPHY2: ##Error getting AppList \(error)")
            }
        }
    }
    
    // NoCropAPPID - 68778aa081d2f0010365558f, StickerMaker - 686df3b631ba179a7ccc2eed
    @objc public func getAllDataByApplicationID(_ completion: @escaping ((AllDataModel?, NSError?) -> Void)) {
        
        let appListUrl = allDatabaseUrl + "/data/app/" + "\(applicationID)"
        guard let urlRequest = configureURLRequest(urlString: appListUrl, apiKey: self.apiKey, requestType: .GET, headerFieldName: "api-key") else {
            let urlMakingErorr = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Couldn't make url"])
            print("COMPHY2: ##InvalidRequestError getAllDataByApplicationIDAndFeatureID")
            completion(nil, urlMakingErorr)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
         
            if let error = error as NSError? {
               print("COMPHY2: ##Error getAllDataUsing AppID error \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("COMPHY2: ##Error getAllDataUsing AppID \(noDataError)")
                completion(nil, noDataError)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard json is [String: Any] else {
                    throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected JSON dictionary"])
                }
                let allDataModel = try JSONDecoder().decode(AllDataModel.self, from: data)
                // populate tagsArrayModel insider feature and featureStyleArr
                if let tags = allDataModel.tags, let features = allDataModel.features {
                    allDataModel.features = allDataModel.mapTagsToFeatures(features: features, tags: tags)
                }
                allDataModel.mapStylesToFeatures()
                saveAllDataJsonInRootDirectory(jsonData: data, fileName: AIIMAGE_COMPHY2_JSON_FILE_NAME)
                print("COMPHY2: ##Success getAllDataUsing AppID")
                completion(allDataModel, nil)
            } catch _ as NSError {
                print("COMPHY2: ##Error getAllDataUsing AppID \(error)")
                completion(nil, error as NSError?)
            }
        }
        task.resume()
    }
    
    // NoCropAPPID - 68778aa081d2f0010365558f, featureID - 67f3c350db59b37913d829b7 (only 1 style for this featureID till date)
    func getAllStyleByApplicationIDAndFeatureID(
        featureID: String,
        page: Int = 1,
        limit: Int = 35,
        completion: @escaping (_ container: StyleContainerComphy2?, _ error: Error?) -> Void
    ) {
        let appListUrl = "\(allDatabaseUrl)/app/\(applicationID)/feature/\(featureID)/styles?page=\(page)&limit=\(limit)"
        
        guard let urlRequest = configureURLRequest(urlString: appListUrl, apiKey: self.apiKey, requestType: .GET, headerFieldName: "api-key") else {
            let urlMakingErorr = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Couldn't make url"])
            print("COMPHY2: ##InvalidRequestError getAllStyleByApplicationIDAndFeatureID")
            completion(nil, urlMakingErorr)
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("COMPHY2: ##Error getAllStyleByApplicationIDAndFeatureID error \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("COMPHY2: ##Error getAllStyleByApplicationIDAndFeatureID \(noDataError)")
                completion(nil, noDataError)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(StyleContainerComphy2.self, from: data)
                print("COMPHY2: ##Success getAllStyleByApplicationIDAndFeatureID")
                completion(decodedResponse, nil)
            } catch {
                print("COMPHY2: ##DecodingError getAllStyleByApplicationIDAndFeatureID \(error)")
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getAllDiscoverAndTagsByApplicationIDAndFeatureID(
        featureID: String,
        completion: @escaping (_ responseModel: TagsResponseModel?, _ error: Error?) -> Void
    ) {
        let appListUrl = allDatabaseUrl + "/app/\(applicationID)/feature/\(featureID)/tags/discover"

        guard let urlRequest = configureURLRequest(urlString: appListUrl, apiKey: self.apiKey, requestType: .GET, headerFieldName: "api-key") else {
            print("COMPHY2: ##InvalidRequestError getAllDiscoverAndTagsByApplicationIDAndFeatureID")
            completion(nil, NSError(domain: "InvalidRequest", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid request URL or headers"]))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("COMPHY2: ##Error getAllDiscoverAndTagsByApplicationIDAndFeatureID: \(error.localizedDescription)")
                completion(nil, error)
                return // ✅ This was missing
            }

            guard let data = data else {
                let noDataError = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("COMPHY2: ##Error getAllDiscoverAndTagsByApplicationIDAndFeatureID: No data received")
                completion(nil, noDataError)
                return
            }

            do {
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(TagsResponseModel.self, from: data)
                print("COMPHY2: ##Success getAllDiscoverAndTagsByApplicationIDAndFeatureID")
                completion(responseModel, nil)
            } catch {
                print("COMPHY2: ##Decoding error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }

        task.resume()
    }

    
    func getAllRefImageListAndByApplicationIDAndFeatureID(featureID: String = "67f3c350db59b37913d829b7") {
        let appListUrl = allDatabaseUrl + "/app/" + "\(applicationID)/" + "feature/" + "\(featureID)/" + "ref-image-lists"
        
        guard let urlRequest = configureURLRequest(urlString: appListUrl, apiKey: self.apiKey, requestType: .GET, headerFieldName: "api-key") else {
            print("COMPHY2: ##InvalidRequestError getAllRefImageListAndByApplicationIDAndFeatureID")
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error as NSError? {
               print("COMPHY2: ##Error getAllRefImageListAndByApplicationIDAndFeatureID error \(error)")
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "NetworkError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("COMPHY2: ##Error getAllRefImageListAndByApplicationIDAndFeatureID \(noDataError)")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let dictionary = json as? [[String: Any]] else {
                    throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected JSON dictionary"])
                }
                print("COMPHY2: ##Success getAllRefImageListAndByApplicationIDAndFeatureID")
            } catch let decodeError as NSError {
                print("COMPHY2: ##Error getAllRefImageListAndByApplicationIDAndFeatureID \(error)")
            }
        }
        task.resume()
    }
    
    func fetchApiRequestModelFromJsonURL(from urlString: String,
                                         completion: @escaping ([String: Any]?, String?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            let error = NSError(domain: "URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to make URL"])
            completion(nil, nil, error)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                completion(nil, nil, error)
                return
            }

            guard let data = data else {
                print("No data received from: \(url)")
                let error = NSError(domain: "Network", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty Data Received"])
                completion(nil, nil, error)
                return
            }

            do {
                // Parse JSON into a dictionary
                guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    let error = NSError(domain: "JSON", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to cast JSON to dictionary"])
                    completion(nil, nil, error)
                    return
                }

                // Convert JSON dictionary back to pretty-printed string
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
                let jsonString = String(data: jsonData, encoding: .utf8)

                completion(dict, jsonString, nil)
            } catch {
                print("Decoding error: \(error)")
                completion(nil, nil, error)
            }
        }.resume()
    }

//    
//    func generateComphy2(jsonURL: URL,
//                         statusCallback: ((NCAiImageUploadStatuss) -> Void)?,
//                         completion: @escaping (URL?, Error?) -> Void) {
//      
//        let urlString = mlBaseUrl + "/generate"
//        guard let url = URL(string: urlString) else {
//            let error = NSError(domain: "InvalidURLError", code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//            completion(nil, error)
//            return
//        }
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(mlAuthorization)"
//        ]
//        
//        statusCallback?(.uploading)
//        
//        uploadRequest = AF.upload(multipartFormData: { multipartFormData in
//            if let jsonData = try? Data(contentsOf: jsonURL) {
//                multipartFormData.append(jsonData, withName: "json_data", fileName: "input.json", mimeType: "application/json")
//            }
//        }, to: url, method: .post, headers: headers)
//        .uploadProgress { progress in
//            print("Upload Progress: \(progress.fractionCompleted)")
//            if progress.fractionCompleted == 1.0 {
//                statusCallback?(.processing)
//            }
//        }
//        .responseData { response in
//            switch response.result {
//            case .success(let data):
//                print("comph2 data: \(String(data: data, encoding: .utf8))")
//                statusCallback?(.completed)
//                let tempZipURL = FileManager.default.temporaryDirectory.appendingPathComponent("comphy2_output.zip")
//                do {
//                    try data.write(to: tempZipURL)
//                    completion(tempZipURL, nil)
//                } catch {
//                    completion(nil, error)
//                }
//                
//            case .failure(let error):
//                if error.isExplicitlyCancelledError {
//                    print("Comphy2 Request was cancelled.")
//                }
//                completion(nil, error)
//            }
//        }
//    }
    
    private func getRequestFor(data: Data) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        let paramName = "json_data"
        
        body += Data("--\(boundary)\r\n".utf8)
        body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
        body += Data("; filename=\"\("config.json")\"\r\n".utf8)
        body += Data("Content-Type: \"content-type header\"\r\n".utf8)
        body += Data("\r\n".utf8)
        body += data
        body += Data("\r\n".utf8)
        body += Data("--\(boundary)--\r\n".utf8);
        
        let postData = body

        let urlString = mlBaseUrl + "/generate"
        let generateKey = "Bearer \(mlAuthorization)"
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue(generateKey, forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        return request
    }
    
    func urlForValidJSON() -> URL? {
        return Bundle.main.url(forResource: "validJSON", withExtension: "json")
    }
    
    func generateComphy2(jsonURL: URL, completion: @escaping (URL?, Error?) -> Void) {
       
//        guard let bundleURL = urlForValidJSON() else {
//            completion(nil, NSError(domain: "Comphy2APIErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "json url error"]))
//            return
//        }
        
        guard let jsonData = try? Data(contentsOf: jsonURL) else {
            completion(nil, NSError(domain: "Comphy2APIErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "json data error"]))
            return
        }
        
        
        let request = getRequestFor(data: jsonData)
        
        let session = URLSession.shared
        task = session.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let responseString = String(data: data, encoding: .utf8) {
                print("Data: \(responseString)")
            } else {
                print("No data or failed to decode as UTF-8")
                }
            if let error = error {
                // TODO: Delete the folder cretaed
                print("data fetching error \(error)")
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, NSError(domain: "Comphy2APIErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
                return
            }
            
            guard httpResponse.statusCode == 200, let data = data else {
                // TODO: Delete the folder cretaed
                completion(nil, NSError(domain: "Comphy2APIErrorDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Non-200 status code received"]))
                return
            }
            
            let tempZipURL = FileManager.default.temporaryDirectory.appendingPathComponent("comphy2_output.zip")
            do {
                try data.write(to: tempZipURL)
                completion(tempZipURL, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task?.resume()
    }
    
   
    
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
//        }
    }
    
}


