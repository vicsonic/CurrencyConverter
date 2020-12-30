//
//  Quotes.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

struct Quote: Codable {
    let code: String
    let value: Double
}

struct Quotes: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let timestamp: Date
    let source: String
    let quotes: [Quote]

    private enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case timestamp
        case source
        case quotes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        terms = try container.decode(String.self, forKey: .terms)
        privacy = try container.decode(String.self, forKey: .privacy)
        let time = try container.decode(Int.self, forKey: .timestamp)
        timestamp = Date(timeIntervalSince1970: TimeInterval(time))
        source = try container.decode(String.self, forKey: .source)
        let dictionary = try container.decode([String: Double].self, forKey: .quotes)
        quotes = dictionary.map{ Quote(code: $0, value: $1) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(terms, forKey: .terms)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
        try container.encode(source, forKey: .source)
        try container.encode(Dictionary(uniqueKeysWithValues: quotes.map{ ($0.code, $0.value) }), forKey: .quotes)
    }
}
