//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 04/01/21.
//

import Foundation

class Converter {
    private let currencies: Currencies
    private let quotes: Quotes

    let currenciesCatalog: [String: Currency]
    let quotesCatalog: [String: Quote]
    private var unitaryConversions: [Currency: Conversion]

    init(currencies: Currencies, quotes: Quotes) {
        self.currencies = currencies
        self.quotes = quotes
        self.currenciesCatalog = Dictionary(uniqueKeysWithValues: currencies.currencies.map{ ($0.code, $0) })
        self.quotesCatalog = Dictionary(uniqueKeysWithValues: quotes.quotes.map{ ($0.code, $0)})
        self.unitaryConversions = [:]
    }

    private func multiply(factor: Double, conversion: Conversion) -> Conversion {
        Conversion(source: conversion.source, value: factor, results: Dictionary(uniqueKeysWithValues: conversion.results.map{($0, ConversionResult(currency: $0, value: $1.value * factor))}))
    }
    
    func convert(source: Currency, value: Double) -> Conversion? {
        guard let conversion = unitaryConversions[source] else {
            guard let sourceQuote = quotesCatalog[source.code] else {
                return nil
            }
            let sourceFactor = 1 / sourceQuote.value
            let results: [Currency: ConversionResult] = Dictionary(uniqueKeysWithValues: currencies.currencies.map{
                do {
                    guard let currencyQuote = quotesCatalog[$0.code] else {
                        throw AppError.Converter.invalidCurrency
                    }
                    let currencyFactor = 1 / currencyQuote.value
                    return ($0, ConversionResult(currency: $0, value: sourceFactor / currencyFactor))
                } catch {
                    fatalError("Invalid Data")
                }
            })
            let conversion = Conversion(source: source, value: value, results: results)
            unitaryConversions[source] = conversion
            return multiply(factor: value, conversion: conversion)
        }
        return multiply(factor: value, conversion: conversion)
    }
}
