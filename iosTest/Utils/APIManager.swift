//
//  APIManager.swift
//  iosTest
//
//  Created by Purushottam on 4/27/19.
//  Copyright © 2019 Purushottam. All rights reserved.
//

import Foundation
import Alamofire


public enum RequestType {
    case withHeader, withoutHeader, withAuthorizationText, withCustomHeader//, jsonEncoding
}
class AlamofireAppManager {
    
    static let session: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
        
    }()
}


struct StatusCode {
    
    static let success : Int = 200
    static let error: Int = 201
    static let failed: Int = 500
    
    
}



public class APIManager{
    
    fileprivate var dataRequest: DataRequest!
    
    
    private var  params: [String: AnyObject]?
    
    public init (_ requestType : RequestType, urlString: String, parameters: [String: AnyObject]? = nil, headers: [String: String] = [String:String](), method: Alamofire.HTTPMethod = .post, withEncoding encoding : URLEncoding = URLEncoding.default) {
        
        self.params = parameters
        
        let sessionsManager = AlamofireAppManager.session
        sessionsManager.startRequestsImmediately = true
        
        let accessToken : String? = UserDefaults.standard.value(forKey: "JWTKey") as? String
        
        
        switch requestType {
            
        case .withAuthorizationText:
            
            let header: [String: String] = ["Authorization": "Basic Og=="]
            
            self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: header)
            break
            
        case .withoutHeader:
            
            self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: nil)
            break
            
        case .withHeader:
            
            if let token = accessToken{
                
                let header : [String : String] = [
                    
                    "X-Requested-With" : "XMLHttpRequest",
                    "Authorization" : "Bearer " + token
                ]
                print(header)
                self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: header)
            }else{
                
                self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: nil)
            }
            
            break
            
        case .withCustomHeader:
            let headers = ["Authorization" : UserDefaults.standard.value(forKey: "JWTKey")! as! String]
            print(headers)
            self.dataRequest = sessionsManager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
            
            break
        
        }
       
    }
    
    
    
    func handleResponse(viewController: UIViewController, loadingOnView view: UIView,withLoadingColor actColor: UIColor = .white,isShowProgressHud: Bool = true,isShowNoNetBanner: Bool = true, isShowAlertBanner: Bool = true,completionHandler: @escaping (Any)-> Void, errorBlock: ((String)->Void)? = nil,failureBlock: ((String)->Void)? = nil){
        
        do {
        
            let googleTest = try NetworkReachabilityManager(host: "www.google.com")
            guard let result = googleTest?.isReachable, result else {
                
                failureBlock?(ErrorMessage.noInternet)
                
                if isShowNoNetBanner{
                    Helper.showToastOnView(message: ErrorMessage.noInternet, view: viewController.view)
                }
                return
            }
            
        } catch {
            print(error)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingView = LoadingView()
        
        if isShowProgressHud {
            
            view.isUserInteractionEnabled = false
            loadingView.layer.zPosition = 100
            loadingView.set(withLoadingView: view, withBackgroundColor: .white, withLoadingIndicatorColor: .gray)
                    view.addSubview(loadingView)
        }
        
        self.dataRequest.responseJSON { (response) in
            
            if isShowProgressHud{
                
                DispatchQueue.main.async {
                    view.isUserInteractionEnabled = true
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    loadingView.removeFromSuperview()
                }
            }
            
            
            let statusCode = response.response?.statusCode ?? 0
            print("statusCode:- \(statusCode)")
            
            switch response.result{
            case .success(let value):
                
                if statusCode == StatusCode.success {
                    completionHandler(value)
                    return
                }
                if statusCode == StatusCode.failed{
                    let message =  ErrorMessage.serverError
                    errorBlock?(message)
                }
                else{
                    let message =  ErrorMessage.unableToGetData
                    errorBlock?(message)
                }
            case .failure(let error):
                print(error)
                    if let headerMSg = response.response?.allHeaderFields as? [String: String] {
                        if let headerMsg = headerMSg["message"] {
                            failureBlock?(headerMsg)
                            return
                        }
                    }
                    let errorMessage = ErrorPredictor.get(errorFromAlamofire: error)
                    
                    failureBlock?(errorMessage)
                
            }
        }
        
        /*
        self.dataRequest.responseJSON { (response) in
            
            print(response.data ?? "No data")
            print(response.timeline)
            print(response.request ?? "No request")
            print(self.params ?? "No Params")
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let val):
                print(val)
            }
        }
        
        */
    }
}



class ErrorPredictor{
    class func get( errorFromAlamofire : Error) -> String{
        
        if let error = errorFromAlamofire as? AFError {
            
            switch error {
            case .invalidURL(let url):
                let errorMessage = "Invalid URL: \(url) - \(error.localizedDescription)"
                return errorMessage
                
            case .parameterEncodingFailed(let reason):
                print("Failure Reason: \(reason)")
                let errorMessage = "Parameter encoding failed: \(reason)"
                return errorMessage
                
            case .multipartEncodingFailed(let reason):

                print("Failure Reason: \(reason)")
                let errorMessage = "Multipart encoding failed: \(reason)"
                return errorMessage
                
            case .responseValidationFailed(let reason):

                print("Failure Reason: \(reason)")
                var errorMessage = "Response validation failed: \(reason)"
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    errorMessage = "Downloaded file could not be read"
                    print("Downloaded file could not be read")
                case .missingContentType(let acceptableContentTypes):
                    errorMessage = "Content Type Missing: \(acceptableContentTypes)"
                    print("Content Type Missing: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    errorMessage = "Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)"
                    print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("Response status code was unacceptable: \(code)")
                    errorMessage = "Response status code was unacceptable: \(code)"
                }
                return errorMessage
                
            case .responseSerializationFailed(let reason):

                print("Failure Reason: \(reason)")
                let errorMessage = "Response serialization failed: \(reason)"
                return errorMessage
            }
            
        } else if let error = errorFromAlamofire as? URLError {
            if error.code == .notConnectedToInternet{
                
                return errorFromAlamofire.localizedDescription
            }
            //URLError occurred:
            let errorMessage = "\(error.localizedDescription)"
            return errorMessage
            
        } else {
            let errorMessage = "Internal Server Error"//\(errorFromAlamofire.localizedDescription)"
            return errorMessage
        }
    }
}


class LoadingView: UIView{
    
    
    public func set(withLoadingView ldView: UIView, withBackgroundColor bg: UIColor, withLoadingIndicatorColor indColor : UIColor){
        
        let size : CGFloat = 80
        self.translatesAutoresizingMaskIntoConstraints = false
        ldView.addSubview(self)
        
        self.widthAnchor.constraint(equalToConstant: size).isActive = true
        self.heightAnchor.constraint(equalToConstant: size).isActive = true
        self.centerXAnchor.constraint(equalTo: ldView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: ldView.centerYAnchor).isActive = true
        
        self.backgroundColor = bg
        self.isUserInteractionEnabled = false
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let indicatorColor : UIColor = .white//actColor == .white ? .black : .white
        
        activityIndicator.color = indicatorColor
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
