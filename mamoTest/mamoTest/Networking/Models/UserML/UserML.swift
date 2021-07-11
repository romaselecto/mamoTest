//
//  UserML.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation

struct UserML: Codable {
    let id: String
    var key: String?
    var value: String?
    var publicName: String?

    enum CodingKeys: String, CodingKey {
        case id, key, value, publicName
    }
}
