//
//  Conversion.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 04/01/21.
//

import Foundation

struct Conversion {
    let source: Currency
    let value: Double
    let results: [Currency: ConversionResult]

    init() {
        self.source = Currency()
        self.value = 0
        self.results = [:]
    }

    init(source: Currency, value: Double, results: [Currency: ConversionResult]) {
        self.source = source
        self.value = value
        self.results = results
    }
}

struct ConversionResult {
    let currency: Currency
    let value: Double
}
