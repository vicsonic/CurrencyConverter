//
//  Currencies.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct Country: Codable {
    let name: String
    let flag: String?
}

struct Currency: Codable {
    let code: String
    let country: Country
}

struct Currencies: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let currencies: [Currency]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        terms = try container.decode(String.self, forKey: .terms)
        privacy = try container.decode(String.self, forKey: .privacy)
        let dictionary = try container.decode([String: String].self, forKey: .currencies)
        currencies = dictionary.map{ Currency(code: $0, country: Country(name: $1, flag: nil)) }
    }
}
