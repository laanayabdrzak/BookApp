//
//  Offer.swift
//  BookAppMVVM
//
//  Created by LAANAYA Abderrazak on 11/7/2023.
//

import Foundation


public struct CommercialOffersResponse: Codable {
    let offers: [Offer]
}


public struct Offer: Codable, Hashable {
    let type: String
    let value: Int
    let sliceValue: Int?
}
