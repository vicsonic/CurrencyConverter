//
//  CurrencyConverterError.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct CurrencyConverterError {
    enum Router: Error {
        case invalidURL
    }

    enum Publisher: Error {
        case request(error: Error)
    }

    enum Store: Error {
        case existingCancellableForRequest
        case invalidFile
        case decoding(error: Error)
    }
}
