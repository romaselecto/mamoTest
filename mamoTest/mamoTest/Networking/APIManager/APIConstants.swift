//
//  APIConstants.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Alamofire
import Foundation

typealias api_success_block = (_ success: Bool, _ errMessage: String?) -> Void
typealias api_full_success_block = (_ success: Bool, _ object: Parameters?, _ errMessage: String?) -> Void
