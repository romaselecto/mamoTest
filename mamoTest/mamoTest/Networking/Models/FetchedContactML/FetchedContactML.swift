//
//  FetchedContactML.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation

struct FetchedContactML {
    var firstName: String
    var lastName: String
    var phoneNumbers: [String]
    var emailAddresses: [String]
    var image: Data?
    var mamoModel: UserML?
    var isFrequent: Bool?
    var isSelected: Bool?
}
