//
//  ParameterEncoding.swift
//  Magic_Tokens
//
//  Created by Jackson Ho on 3/19/19.
//  Copyright © 2019 Jackson Ho. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed."
    case missingURL = "URL is nil"
}
