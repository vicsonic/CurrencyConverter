//
//  Router.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

protocol Router {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var url: URL? { get }
    var authenticationType: AuthenticationType { get }
    var authenticationKey: String? { get }
}

extension Router {
    var url: URL? {
        URL(string: baseURL + path)
    }

    var method: HTTPMethod {
        .get
    }

    var authenticationType: AuthenticationType {
        .url(name: "")
    }

    var authenticationKey: String? {
        nil
    }
}
