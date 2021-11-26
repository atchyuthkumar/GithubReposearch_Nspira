//
//  APIService.swift
//  GitHubRepoSearch_Nspira
//
//  Created by HTS on 26/11/21.
//

import Foundation

public typealias BaseAPICompletion = (Data?, URLResponse?, Error?) -> Swift.Void

open class APIService {
        
    var session: URLSession
    
    public init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func get(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, completion: @escaping BaseAPICompletion) {
        let request = Request(url: url, method: .GET, parameters: parameters, headers: headers, body: nil)
        let buildRequest = request.request()
        if let urlRequest = buildRequest.request {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion(nil, nil, buildRequest.error)
        }
    }
    
}
