//
//  APIManager.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import Alamofire
import CodableAlamofire

final class APIManager {
    // MARK: - Const

    private let failureNoInternet = ("No Internet. Please, make sure you are connected and try again.", "You are offline")

    // MARK: - Inside Enums

    enum Result<T> {
        case success(T)
        case failure(String)
    }

    enum ResultNoResponse {
        case success
        case failure(String)
    }

    enum APIError: Error {
        case requestFailed
        case jsonConversionFailure
        case invalidData
        case responseUnsuccessful
        case jsonParsingFailure
        var localizedDescription: String {
            switch self {
            case .requestFailed: return "Request Failed"
            case .invalidData: return "Invalid Data"
            case .responseUnsuccessful: return "Response Unsuccessful"
            case .jsonParsingFailure: return "JSON Parsing Failure"
            case .jsonConversionFailure: return "JSON Conversion Failure"
            }
        }
    }

    // MARK: - Properties

    private static var sharedNetworkManager: APIManager = {
        APIManager()
    }()

    // MARK: - Accessors

    class func shared() -> APIManager {
        return sharedNetworkManager
    }

//    Initialization
    private init() {}


    // MARK: - PERFORM METHODS

    private func performRequest<T: Codable>(router: BaseRouter, completion: @escaping (Result<T>) -> Void) {
        print("API -->: \(router.path), params: \(String(describing: router.parameters ?? nil)) ")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        Alamofire.request(router).validate().responseDecodableObject(keyPath: router.keyPath, decoder: decoder) { (response: DataResponse<T>) in
            guard response.result.error == nil else {
                let statusCode = response.response?.statusCode ?? -1
                print("Status Code = \(statusCode)")
                //                if let requestId = response.response?.allHeaderFields["x-request-id"] {
                //                    print("Request Id = \(requestId)")
                //                }
                let errMessage = self.getErrorText(self.jsonFromData(response.data))
                print("Error: \(errMessage)")
                completion(.failure(errMessage))

                
                return
            }
            
            if let requestId = response.response?.allHeaderFields["x-request-id"] {
                print("Request Id = \(requestId)")
            }

            if let object = response.result.value {
                print("SUCCESS DECODE")
                completion(.success(object))
            }
            
            return
        }
    }
    
    // -------------------------------------------------------------------------------------------

    // MARK: - HANDLE ERRORS

    // -------------------------------------------------------------------------------------------

    private func jsonFromData(_ data: Data?) -> Parameters? {
        guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
            return nil
        }

        return json
    }

    private func getErrorText(_ dict: Parameters?) -> (String) {
        /*
         "error": {
         "code": 400,
         "message": "ValidationErrors",
         "errors": [
         "The email format is invalid.",
         "The password must be at least 6 characters."
         ]
         }
         */
        print("Error: \(String(describing: dict))")

        guard let dict = dict, let errorBlock = dict["error"] as? [String: Any] else {
            return ("Something went wrong.")
        }

        if let errorArray = errorBlock["errors"] as? [String],
           errorArray.count > 0, let errorFirstMsg = errorArray.first
        {
            return errorFirstMsg
        } else if let err = errorBlock["message"] as? String {
            return err
        } else {
            return ("Something went wrong.")
        }
    }

    // -------------------------------------------------------------------------------------------

    // MARK: - USERS METHODS

    // -------------------------------------------------------------------------------------------

    func accounts<T: Codable>(_ params: Parameters, completion: @escaping (Result<T>) -> Void) {
        let router = UsersRouter(anEndpoint: .accounts(params))
        performRequest(router: router, completion: completion)
    }

    func frequents<T: Codable>(completion: @escaping (Result<T>) -> Void) {
        let router = UsersRouter(anEndpoint: .frequents)
        performRequest(router: router, completion: completion)
    }

}
