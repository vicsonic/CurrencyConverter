//
//  ConversionCalculator.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 04/01/21.
//

import Foundation

class ConversionCalculator {
    private let currencies: Currencies
    private let quotes: Quotes

    init(currencies: Currencies, quotes: Quotes) {
        self.currencies = currencies
        self.quotes = quotes
    }
    
    func calculateResult(for value: Double) -> Conversion {
        
    }
}
