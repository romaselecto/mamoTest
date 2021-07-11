//
//  UsersRouter.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import Alamofire

enum UsersEndpoint {
    case frequents
    case accounts(Parameters)
}

class UsersRouter: BaseRouter {
    fileprivate var endPoint: UsersEndpoint

    init(anEndpoint: UsersEndpoint) {
        endPoint = anEndpoint
    }

    override var method: HTTPMethod {
        switch endPoint {
        case .accounts:
            return .post
        case .frequents:
            return .get
        }
    }

    override var path: String {
        switch endPoint {
        case .frequents:
            return "frequents"
        case .accounts:
            return "accounts"
        }
    }

    override var parameters: Parameters? {
        switch endPoint {
        case let .accounts(params):
            return params
        case .frequents:
            return nil
        }
    }

    override var keyPath: String? {
        switch endPoint {
        case .accounts:
            return "mamoAccounts"
        case .frequents:
            return "frequents"
        }
    }

    override var encoding: ParameterEncoding? {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
