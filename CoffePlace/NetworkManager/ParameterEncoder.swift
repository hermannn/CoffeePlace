//
//  ParameterEncoder.swift
//  Guarana
//
//  Created by Hermann Dorio on 21/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

enum NetworkError: String, Error {
    case parametersNil = "param are nil"
    case encode = "encoding failed"
    case missingUrl = "miss URL"
}

protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, parameters: Parameters) throws
}
