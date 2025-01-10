//
//  User.swift
//  Moonshot
//
//  Created by Gary on 20/12/2024.
//

import Foundation

struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}
