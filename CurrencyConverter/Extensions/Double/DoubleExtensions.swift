//
//  DoubleExtensions.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        return (self * 1000).rounded() / 1000
    }
}
