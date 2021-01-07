//
//  Currencies.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct LocaleCurrency: Hashable {
    let code: String
    let symbol: String

    init?(locale: Locale) {
        guard let code = locale.currencyCode,
              let symbol = locale.currencySymbol else {
            return nil
        }
        self.code = code
        self.symbol = symbol
    }

    static func == (lhs: LocaleCurrency, rhs: LocaleCurrency) -> Bool {
        return lhs.code == rhs.code && lhs.symbol == rhs.symbol
    }

    static var availableCurrencies: [String: [LocaleCurrency]] = {
        let currencies = Set(Locale.availableIdentifiers.compactMap{ LocaleCurrency(locale: Locale(identifier: $0)) })
        return Dictionary(grouping: currencies, by: { $0.code })
    }()

    static func currencies(for code: String) -> [LocaleCurrency] {
        guard let currencies = availableCurrencies[code] else {
            return []
        }
        return currencies
    }
}

struct Currency: Codable, Hashable {
    let code: String
    let name: String
    let symbols: [String]

    init() {
        self.code = ""
        self.name = ""
        self.symbols = []
    }

    init(code: String, name: String, symbols: [String]) {
        self.code = code
        self.name = name
        self.symbols = symbols
    }
}

struct Currencies: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let currencies: [Currency]

    private enum CodingKeys: String, CodingKey {
        case success
        case terms
        case privacy
        case currencies
    }

    init() {
        self.success = false
        self.terms = ""
        self.privacy = ""
        self.currencies = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.success = try container.decode(Bool.self, forKey: .success)
        self.terms = try container.decode(String.self, forKey: .terms)
        self.privacy = try container.decode(String.self, forKey: .privacy)
        let dictionary = try container.decode([String: String].self, forKey: .currencies)
        self.currencies = dictionary.map{ Currency(code: $0, name: $1, symbols: LocaleCurrency.currencies(for: $0).map{ $0.symbol }) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(terms, forKey: .terms)
        try container.encode(privacy, forKey: .privacy)
        try container.encode(Dictionary(uniqueKeysWithValues: currencies.map{ ($0.code, $0.name) }), forKey: .currencies)
    }
}
