//
//  AppError.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct AppError {
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

    enum Storage: Error {
        case read(error: Error)
        case write(error: Error)
        case fileNotFound
    }

    enum Converter: Error {
        case invalidCurrency
    }

    enum Bindable: Error {
        case unknown
    }
}
