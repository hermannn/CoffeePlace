//
//  EndpointType.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

protocol EndpointType {
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpTask: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    func addPathToURL() -> URL
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum HTTPTask {
    case request
    case requestParameters(bodyParam: Parameters?, urlParam: Parameters?)
    case requestParametersHeaders(bodyParam: Parameters?, urlParam: Parameters?, headerParam: HTTPHeaders?)
}
