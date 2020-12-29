//
//  APISettingsRouter.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct APISettingsRouter: Router {

    var baseURL: String { "" }
    var path: String { "" }

    var url: URL? {
        Bundle.main.url(forResource: "APISettings", withExtension: "plist")
    }
}
