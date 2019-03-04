//
//  JSONParameterEncoder.swift
//  Guarana
//
//  Created by Hermann Dorio on 21/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation


struct JSONParameterEncoder: ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        }catch {
            throw NetworkError.encode
        }
    }
}
