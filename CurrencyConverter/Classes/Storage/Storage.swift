//
//  Storage.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

protocol ReadStorage {
    func fetchData(key: String) throws -> Data
    func fetchData(key: String, completion: ((Result<Data, Error>) -> Void)?)
}

protocol WriteStorage {
    func store(value: Data, key: String) throws
    func store(value: Data, key: String, completion: ((Result<Bool, Error>) ->Void)?)
}

typealias Storage = ReadStorage & WriteStorage
