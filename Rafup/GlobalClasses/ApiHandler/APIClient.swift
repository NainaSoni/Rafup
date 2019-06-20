
//
//  APIHandler.swift
//  Vookar
//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import UIKit
import SystemConfiguration

public enum Errors: Int, Error {
    case unknown = 404
    case wrongCredentials = 400
    case noInternet = 503
    case invalidURL = 405
    var localizedDescription: String {
        switch self {
        case .unknown:
            return NSLocalizedString("\(Errors.self)_\(self)", tableName: String(describing: self), bundle: Bundle.main, value: "Unknown error occurred", comment: "")
        case .noInternet:
            return NSLocalizedString("\(Errors.self)_\(self)", tableName: String(describing: self), bundle: Bundle.main, value: "No internet connection", comment: "")
        case .invalidURL:
            return NSLocalizedString("\(Errors.self)_\(self)", tableName: String(describing: self), bundle: Bundle.main, value: "Method not allowed", comment: "")
        case .wrongCredentials:
            return NSLocalizedString("\(Errors.self)_\(self)", tableName: String(describing: self), bundle: Bundle.main, value: "Login details are not correct", comment: "")
        }
    }
    public var _code: Int { return self.rawValue }
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public typealias APISuccessHandler = (_ jsonObject: [String:Any]?) ->Void
public typealias APIFailureHandler = (_ error: Error?, _ jsonObject: [String:Any]?) ->Void
public typealias APITokenExpireHandler = () ->Void

public protocol APIRequirement {
    
    static var baseURL: String {get}
    var apiHeader: [String:String]! {get}
    var apiPath: String {get}
    var imagePath: String {get}
    var methodPath: String { get }
    
    func finalParameters(from parameters: [String : Any]) -> [String : Any]
    func finalHeader(from parameters: [String : String]) -> [String : String]
    func tokenDidExpired() -> Void
    @discardableResult func request(method: HTTPMethod, with parameters: [String : Any]!, isValidate validate:Bool, completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) -> URLSessionDataTask?
    @discardableResult func requestUpload(with parameters: [String: Any]?, files: [String: Any]? , isValidate validate:Bool, completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) -> URLSessionDataTask?
}
/*
 func validatedResponse(_ response: DataResponse<Any>, success:APISuccessHandler?, failed:APIFailureHandler?)
 func validatedResponse(_ response: SessionManager.MultipartFormDataEncodingResult, success:APISuccessHandler?, failed:APIFailureHandler?)
 */


extension APIRequirement {
    
    @discardableResult func request(method: HTTPMethod = .post, with parameters: [String : Any]!, isValidate validate:Bool = true, completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) -> URLSessionDataTask? {
        if !Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                Global.showAlert(withMessage:ConstantsMessages.kConnectionFailed)
            }
            Global.dismissLoadingSpinner()
            return nil
        } else {
            let finalParameters  = self.finalParameters(from: parameters ?? [String:Any]())
            print("\n**** Request method: \(method, apiPath)\n") // (method, apiPath + methodPath)
            
            if (finalParameters["method"] as! String == API.updateProfile.rawValue){
            }else{print(finalParameters)}
            
            guard var url = URLComponents(string: apiPath) else { //URLComponents(string: apiPath + methodPath)
                print("Get an error")
                Global.dismissLoadingSpinner()
                return nil
            }
            
            if method == .get, finalParameters.count > 0 {
                var items = [URLQueryItem]()
                
                for (key,value) in finalParameters {
                    items.append(URLQueryItem(name: key, value: "\(value)"))
                }
                
                items = items.filter{!$0.name.isEmpty}
                
                if !items.isEmpty {
                    url.queryItems = items
                }
            }
            
            let session = URLSession.shared
            
            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }

            var urlRequest = URLRequest(url: url.url!)
            
            //MARK: HTTPMethod
            urlRequest.httpMethod = method.rawValue
            
            // MARK:- HeaderField
            let finalHeaders  = self.finalHeader(from: apiHeader)
            
            for (key, value) in finalHeaders {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            //MARK: Request Timeout Time
            urlRequest.timeoutInterval = TimeInterval(ApiConstants.apiTimeoutTime)
            
            if finalParameters.count > 0, method != .get {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: finalParameters, options: [])
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // **** Make the request **** //
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
                // make sure we got data
                if validate {
                    self.validatedResponse(DataResponse(request: urlRequest, response: response as? HTTPURLResponse, data: data, result: (data != nil ) ? Result.success(self.getJSONObject(data: data!)): Result.failure(error!)), success: { (jsonObject) in
                        completionHandler?(jsonObject, nil)
                    }, failed: { (error, json) in
                        completionHandler?(json, error)
                    })
                } else {
                    guard let data = data, error == nil else { completionHandler?(nil, error); return }
                    let json = self.getJSONObject(data: data)
                    print("\n**** Response: \(json)\n")
                    completionHandler?(json, nil)
                }
            })
            task.resume()
            return task
        }
    }
    
    @discardableResult func requestUpload(with parameters: [String: Any]?, files: [String: Any]? , isValidate validate:Bool = true, completionHandler:((_ jsonObject: [String: Any]?, _ error: Error?) -> Void)?) -> URLSessionDataTask? {
        
        if !Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                 Global.showAlert(withMessage:ConstantsMessages.kConnectionFailed)
            }
            Global.dismissLoadingSpinner()
            return nil
        } else {
            let finalParameters  = self.finalParameters(from: parameters ?? [String:Any]())
            print("\n**** Request method: POST, \(apiPath)\n") //(apiPath + methodPath)
            print(finalParameters)
            
            guard let url = URL(string: apiPath) else { //URL(string: apiPath + methodPath)
                print("Get an error")
                Global.dismissLoadingSpinner()
                return nil
            }
            
            let session = URLSession.shared
            
            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
            
            var urlRequest = URLRequest(url: url)
            
            //MARK: HTTPMethod
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            
            //Generate boundary string.
            let boundary = generateBoundaryString()
            
            // MARK:- HeaderField
            let finalHeaders  = self.finalHeader(from: apiHeader)
            
            for (key, value) in finalHeaders {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //MARK: Request Timeout Time
            urlRequest.timeoutInterval = TimeInterval(ApiConstants.apiTimeoutTime)
            
            if finalParameters.count > 0 {
                do {
                    urlRequest.httpBody = try createBody(with: finalParameters, files: files, boundary: boundary)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // **** Make the request **** //
            let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, response, error) in
                // make sure we got data
                if validate {
                    self.validatedResponseMultipart(DataResponse(request: urlRequest, response: response as? HTTPURLResponse, data: data, result: (data != nil ) ? Result.success(self.getJSONObject(data: data!)): Result.failure(error!)), success: { (jsonObject) in
                        completionHandler?(jsonObject, nil)
                    }, failed: { (error, json) in
                        completionHandler?(json, error)
                    })
                } else {
                    guard let data = data, error == nil else { completionHandler?(nil, error); return }
                    let json = self.getJSONObject(data: data)
                    print("\n**** Response: \(json)\n")
                    completionHandler?(json, nil)
                }
            })
            task.resume()
            return task
        }
    }
}


extension APIRequirement {
    func finalParameters(from parameters: [String : Any]) -> [String : Any] { return parameters }
    func tokenDidExpired() -> Void { }
}

extension APIRequirement {
    
    fileprivate func validatedResponse(_ response: DataResponse<Any>, success:APISuccessHandler?, failed:APIFailureHandler?) {
        
        if let data = response.data {
            _ = String.init(data: data, encoding: String.Encoding.utf8)
        }
        
        switch response.result {
            
        case .success(let JSON):
            print("Success with JSON: \(Global.stringifyJson(JSON))")
            let response = JSON as! [String:Any]
            /*guard Global.getInt(for: response["logout"] ?? 0) == 0 else {
                self.tokenDidExpired()
                return
            }*/
            guard Global.getInt(for: response["StatusCode"] ?? 0) != 403 else { //Handle access code expire code
                self.tokenDidExpired()
                return
            }
            // Successfullu recieve response from server
            guard Global.getInt(for: response["StatusCode"] ?? 0) != 200 else {
                // status = 200 return data to controller
                success!(response) // Success response
                return
            }
            var newError:NSError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo:nil)
            var messageString = ""
            if let message = response["ResponseMessage"] as? String {
                let messageStr = (message)
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.caseInsensitive])
                let range = NSMakeRange(0, messageStr.count)
                let htmlLessString :String = regex.stringByReplacingMatches(in: messageStr, options: [], range:range, withTemplate: "")
                newError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo: [NSLocalizedDescriptionKey : htmlLessString])
                messageString = htmlLessString
            }
            
            if messageString != "" {
                DispatchQueue.main.async {
                    Global.showAlert(withMessage:messageString)
                }
            } else {
                DispatchQueue.main.async {
                    Global.showAlert(withMessage: ConstantsMessages.kSomethingWrong)
                }
            }
            
            guard let failedHandler = failed else {
//                if messageString != "" {
//                    Global.showAlert(withMessage:messageString)
//                }
                return
            }
            failedHandler(newError, response)
            
        case .failure(let error):
            guard let failedHandler = failed else {
                if let data = response.data {
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage:ConstantsMessages.kNetworkFailure)
                    }
                    let responceData = String(data: data, encoding:String.Encoding.utf8)!
                    print("**** Serialization****\n\(responceData) \n ****")
                    //let requestURLstring = response.request?.url?.description
                    //callIssueAPI(requestURLstring ?? "", response: responceData)
                } else {
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage:ConstantsMessages.kConnectionFailed)
                    }
                }
                
                return
            }
            print("**** Failed: \(error)")
            failedHandler(error, nil)
        }
    }
    
    
    fileprivate func validatedResponseMultipart(_ response: DataResponse<Any>, success:APISuccessHandler?, failed:APIFailureHandler?) {
        
        switch response.result {
            
        case .success( _):
            if response.data != nil  {
                print("Success with JSON: \(String(describing: String.init(data: response.data!, encoding: String.Encoding.utf8)))")
                
                _ = String.init(data: response.data!, encoding: String.Encoding.utf8)
            }
            guard let response = response.result.value as? [String: Any] else {
                
                //  Constants.kAppDelegate.logout(forUser: "")
                guard let failedHandler = failed else {
                    DispatchQueue.main.async {
                        Global.showAlert(withMessage:ConstantsMessages.kConnectionFailed)
                    }
                    return
                }
                failedHandler(NSError(domain: Constants.kAppDisplayName, code: 404, userInfo:nil), nil)
                return
            }
            print("Success with JSON: \(Global.stringifyJson(response))")
            /*guard Global.getInt(for: response["logout"] ?? 0) == 0 else {
                self.tokenDidExpired()
                return
            }*/
            guard Global.getInt(for: response["StatusCode"] ?? 0) != 403 else { //Handle access code expire code
                self.tokenDidExpired()
                return
            }
            // Successfullu recieve response from server
            guard Global.getInt(for: response["StatusCode"] ?? 0) != 200 else {
                // status = 200 return data to controller
                success!(response) // Success response
                return
            }
            var newError:NSError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo:nil)
            var messageString = ""
            if let message = response["ResponseMessage"] as? String {
                let messageStr = (message)
                let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.caseInsensitive])
                let range = NSMakeRange(0, messageStr.count)
                let htmlLessString :String = regex.stringByReplacingMatches(in: messageStr, options: [], range:range, withTemplate: "")
                newError = NSError(domain: Constants.kAppDisplayName, code: 404, userInfo: [NSLocalizedDescriptionKey : htmlLessString])
                messageString = htmlLessString
            }
            if messageString != "" {
                DispatchQueue.main.async {
                    Global.showAlert(withMessage:messageString)
                }
            }
            guard let failedHandler = failed else {
                return
            }
            
            failedHandler(newError, response)
        case .failure(let error):
            guard let failedHandler = failed else {
                DispatchQueue.main.async {
                    Global.showAlert(withMessage:ConstantsMessages.kConnectionFailed)
                }
                return
            }
            failedHandler(error, nil)
        }
    }
    
    private func getJSONObject(data:Data) -> [String:Any] {
        var responseData = [String: Any]()
        do {
            responseData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        } catch let error {
            print("Request failed with error: \(error)")
        }
        return responseData
    }
}

/// Used to store all data associated with a serialized response of a data or upload request.
fileprivate struct DataResponse<Value> {
    /// The URL request sent to the server.
    fileprivate let request: URLRequest?
    
    /// The server's response to the URL request.
    fileprivate let response: HTTPURLResponse?
    
    /// The data returned by the server.
    fileprivate let data: Data?
    
    /// The result of response serialization.
    fileprivate let result: Result<Value>
    
    
    /// Returns the associated value of the result if it is a success, `nil` otherwise.
    fileprivate var value: Value? { return result.value }
    
    /// Returns the associated error value if the result if it is a failure, `nil` otherwise.
    fileprivate var error: Error? { return result.error }
    
    var _metrics: AnyObject?
    
    /// Creates a `DataResponse` instance with the specified parameters derived from response serialization.
    ///
    /// - parameter request:  The URL request sent to the server.
    /// - parameter response: The server's response to the URL request.
    /// - parameter data:     The data returned by the server.
    /// - parameter result:   The result of response serialization.
    /// - parameter timeline: The timeline of the complete lifecycle of the `Request`. Defaults to `Timeline()`.
    ///
    /// - returns: The new `DataResponse` instance.
    fileprivate init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: Result<Value>)
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}

/// Used to represent whether a request was successful or encountered an error.
///
/// - success: The request and all post processing operations were successful resulting in the serialization of the
///            provided associated value.
///
/// - failure: The request encountered an error resulting in a failure. The associated values are the original data
///            provided by the server as well as the error that caused the failure.
fileprivate enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    fileprivate var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    fileprivate var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    fileprivate var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    fileprivate var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

extension APIRequirement {
    
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The `multipart/form-data` boundary
    ///
    /// - returns:                The `Data` of the body of the request
    
    private func createBody(with parameters: [String: Any]?, files: [String: Any]? = nil, boundary: String) throws -> Data {
        var body = Data()
        
        //Parameters Add
        if parameters != nil {
            for (key, value) in parameters! {
                if value is [String:Any] {
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        // here "jsonData" is the dictionary encoded in JSON data
                        
                        let decoded = String(data: jsonData, encoding: String.Encoding.ascii)
                        // here "decoded" is of type `Any`, decoded from JSON data
                        
                        // you can now cast it with the right type
                        if let dictFromJSON = decoded {
                            // use dictFromJSON
                            body.append("\(dictFromJSON)\r\n")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                } else if value is [AnyObject] {
                    for item in value as! [AnyObject] {
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        if item is String {
                            body.append("\(item)\r\n")
                        } else {
                            do {
                                
                                let jsonData = try JSONSerialization.data(withJSONObject: item, options: [])
                                // here "jsonData" is the dictionary encoded in JSON data
                                
                                let decoded = String(data: jsonData, encoding: String.Encoding.utf8)
                                // here "decoded" is of type `Any`, decoded from JSON data
                                
                                // you can now cast it with the right type
                                if let dictFromJSON = decoded {
                                    // use dictFromJSON
                                    body.append("\(dictFromJSON)\r\n")
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.append("\(value)\r\n")
                }
            }
        } 
        
        // Attach image
        if let files = files {
            for (key, value) in files {
                if value is UIImage {
                    let imageData = UIImageJPEGRepresentation(value as! UIImage , 1.0)
                    print("\(key).jpg")
                    let mimetype = "image/jpg"
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n")
                    body.append("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(imageData ?? Data())
                    body.append("\r\n")
                } else if value is [UIImage] {
                    for (index, item) in (value as! [UIImage]).enumerated() {
                        let imageData = UIImageJPEGRepresentation(item ,1.0)
                        print("\(key)\(index).jpg")
                        let mimetype = "image/jpg"
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)[\(index)]\"; filename=\"\(key)\(index).jpg\"\r\n")
                        body.append("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(imageData ?? Data())
                        body.append("\r\n")
                    }
                    //Other File Code Later
                }else if value is URL {
                    let url = value as! URL
                    let data = try Data(contentsOf: url)
                    print("\(key).mp4")
                    let mimetype = "video/mp4"
                    body.append("--\(boundary)\r\n")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).mp4\"\r\n")
                    body.append("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(data)
                    body.append("\r\n")
                }else if value is [URL] {
                    for (index, item) in (value as! [URL]).enumerated() {
                        let url = item
                        let data = try Data(contentsOf: url)
                        print("\(key)\(index).mp4")
                        let mimetype = "video/mp4"
                        body.append("--\(boundary)\r\n")
                        body.append("Content-Disposition: form-data; name=\"\(key)[\(index)]\"; filename=\"\(key)\(index).mp4\"\r\n")
                        body.append("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data)
                        body.append("\r\n")
                    }
                }
            }
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}


