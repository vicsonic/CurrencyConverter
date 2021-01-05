//
//  StringExtensions.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

extension String {
    func replacingFirstOccurrence(of string: String, with replacement: String) -> String {
        guard let range = self.range(of: string) else {
            return self
        }
        return replacingCharacters(in: range, with: replacement)
    }
}
