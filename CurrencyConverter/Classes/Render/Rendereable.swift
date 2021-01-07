//
//  Rendereable.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 06/01/21.
//

import Foundation

protocol Rendereable { }

extension Array: Rendereable where Element: Rendereable { }

protocol Renderizer {
    associatedtype R: Rendereable
    func update(using rendereable: R)
}

extension ConversionResult: Rendereable {
    func amount() -> String {
        String(format: "%.2f", value)
    }
}
extension Currency: Rendereable { }
