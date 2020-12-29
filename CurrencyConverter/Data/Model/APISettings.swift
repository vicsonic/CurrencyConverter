//
//  APISettings.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

struct APISettings: Codable {
    let apiKey: String
    let baseURL: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "API_KEY"
        case baseURL = "BASE_URL"
    }
}
