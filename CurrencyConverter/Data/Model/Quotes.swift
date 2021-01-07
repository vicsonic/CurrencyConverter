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

    init() {
        self.success = false
        self.terms = ""
        self.privacy = ""
        self.timestamp = Date()
        self.source = ""
        self.quotes = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.terms = try container.decode(String.self, forKey: .terms)
        self.privacy = try container.decode(String.self, forKey: .privacy)
        let timestamp = try container.decode(Int.self, forKey: .timestamp)
        self.timestamp = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let source = try container.decode(String.self, forKey: .source)
        self.source = source
        let dictionary = try container.decode([String: Double].self, forKey: .quotes)
        quotes = dictionary.map{ Quote(code: $0.replacingFirstOccurrence(of: source, with: ""), value: $1) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(terms, forKey: .terms)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
        try container.encode(source, forKey: .source)
        try container.encode(Dictionary(uniqueKeysWithValues: quotes.map{ (source.appending($0.code), $0.value) }), forKey: .quotes)
    }
}
