//
//  Store.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation

protocol Store {
    associatedtype T: Codable
    var builder: PublisherBuilder { get }
}
