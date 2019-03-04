//
//  URLParametersEncoder.swift
//  Guarana
//
//  Created by Hermann Dorio on 21/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

struct URlParametersEncoder: ParameterEncoder {
   
    static func encode(urlRequest: inout URLRequest, parameters: Parameters)  throws {
        guard let url = urlRequest.url else {
            throw NetworkError.missingUrl
        }
        if var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponent.queryItems = [URLQueryItem(name: "", value: nil)]
            for (key, value) in parameters {
                let queryParam = URLQueryItem(name: key, value: "\(value)")
                urlComponent.queryItems?.append(queryParam)
            }
            if let urlBuild = urlComponent.url {
                urlRequest.url = urlBuild
            }
        }
    }
}
