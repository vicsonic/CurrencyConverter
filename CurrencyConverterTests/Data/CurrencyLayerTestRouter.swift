//
//  CurrencyLayerTestRouter.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

enum CurrencyLayerTestRouter: String, Router {
    case list
    case live

    var baseURL: String { "" }
    var path: String { "" }

    var url: URL? {
        Bundle.main.url(forResource: rawValue, withExtension: "json")
    }
}
