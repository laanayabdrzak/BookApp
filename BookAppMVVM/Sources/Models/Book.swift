//
//  Book.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import Foundation

public struct Book: Codable, Hashable {
    let isbn: String
    let title: String
    let price: Int
    let cover: String
    let synopsis: [String]
}
