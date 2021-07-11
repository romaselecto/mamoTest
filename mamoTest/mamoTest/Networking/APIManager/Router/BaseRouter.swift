//
//  BaseRouter.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import Alamofire
import Foundation

let kServerBaseURL = AppSettings.serverUrl

class BaseRouter: APIConfiguration {
    init() {}

    var encoding: ParameterEncoding? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var method: HTTPMethod {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var path: String {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var parameters: Parameters? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    var keyPath: String? {
        fatalError("[\(self) - \(#function))] Must be overridden in subclass")
    }

    func asURLRequest() throws -> URLRequest {
        let url = AppSettings.serverUrl

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 5


        if let encoding = encoding {
            return try encoding.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}
