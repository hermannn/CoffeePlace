//
//  Router.swift
//  Guarana
//
//  Created by Hermann Dorio on 19/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation


class Router<Endpoint: EndpointType> {
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    func request(_ route: Endpoint, completion: @escaping(Result, Data?) -> ()) {
        createRequest(route: route) { (result, data) in
            switch result {
                case .success:
                    completion(.success, data)
                case .error(let msg):
                    completion(.error(msg), nil)
                }
            }
    }
    
    func createRequest(route: Endpoint, completionHandler: @escaping (Result, Data?) -> ())   {
        let fullURL = route.addPathToURL()
        var urlRequest = URLRequest(url: fullURL)
        urlRequest.httpMethod = route.httpMethod.rawValue
        do {
            switch route.httpTask {
            case .requestParameters(bodyParam: nil, urlParam: let urlParam):
                try configureParameter(bodyParam: nil, urlParam: urlParam, request: &urlRequest)
            default:
                break
                
            }
            guard let urlReady = urlRequest.url else { return }
            task = session.dataTask(with: urlReady, completionHandler: { (data, response, error) in
                if error != nil {
                    completionHandler(Result.error(error?.localizedDescription ?? "error"), nil)
                }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completionHandler(Result.success, data)
                }else {
                    completionHandler(Result.error("error code request"), nil)
                }
            })
            task?.resume()
        }catch {
            completionHandler(Result.error(error.localizedDescription), nil)
        }
    }
    
    func configureParameter(bodyParam: Parameters?, urlParam: Parameters?, request: inout URLRequest) throws {
        do {
            if let param = urlParam {
                try URlParametersEncoder.encode(urlRequest: &request, parameters: param)
            }
            if let param = bodyParam {
                try JSONParameterEncoder.encode(urlRequest: &request, parameters: param)
            }
        }catch {
            throw error
        }
    }
}
