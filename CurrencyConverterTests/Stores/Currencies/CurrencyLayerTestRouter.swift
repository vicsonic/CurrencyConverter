//
//  CurrencyLayerTestRouter.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

enum CurrencyLayerTestRouter: Router {
    case list
    case live

    var baseURL: String { "" }

    var path: String {
        self.rawValue
    }

    var url: URL? {
        Bundle.main.url(forResource: path, withExtension: "json")
    }
}
