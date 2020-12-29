//
//  CurrencyLayerRouter.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

enum CurrencyLayerRouter: String, Router {

    case list
    case live

    var baseURL: String {
        AppSettings.shared.apiSettings?.baseURL ?? ""
    }

    var path: String {
        rawValue
    }

    var authenticationType: AuthenticationType {
        .url(name: "access_key")
    }

    var authenticationKey: String? {
        AppSettings.shared.apiSettings?.apiKey
    }
}
