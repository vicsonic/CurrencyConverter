//
//  Localizable.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 07/01/21.
//

import Foundation

// MARK: - Localizable

protocol Localizable {
    var localized: String { get }
}

extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return NSLocalizedString("\(String(describing: type(of: self))).\(self)",
            tableName: "Localizable",
            bundle: Bundle.main,
            value: "",
            comment: "")
    }

    func localizedWith(args: [CVarArg]) -> String {
        return String(format: localized, arguments: args)
    }
}

extension String {
    enum MainScene: String, Localizable {
        case title
    }

    enum CurrenciesScene: String, Localizable {
        case title
    }

    enum ConverterScene: String, Localizable {
        case textFieldPlaceholder
        case footer
    }
}
