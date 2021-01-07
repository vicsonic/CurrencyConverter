//
//  StorageOwner.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation
import Combine

protocol StorageOwner {
    var storage: Storage { get }
    func fetch<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D) throws -> T
    func fetch<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D, success: ((T) -> Void)?, failure: ((Error) -> Void)?)
    func store<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E) throws
    func store<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E, success: (() -> Void)?, failure: ((Error) -> Void)?)
    func delete(key: String) throws
    func buildFetchFuture<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D) -> Future<T, Error>
    func buildStoreFuture<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E) -> Future<Void, Error>
}

extension StorageOwner {
    func fetch<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D) throws -> T {
        let data = try storage.fetchData(key: key)
        return try decoder.decode(T.self, from: data as! D.Input)
    }

    func fetch<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D, success: ((T) -> Void)?, failure: ((Error) -> Void)?) {
        storage.fetchData(key: key) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try decoder.decode(T.self, from: data as! D.Input)
                    success?(decoded)
                } catch {
                    failure?(error)
                }
            case .failure(let error):
                failure?(error)
            }
        }
    }

    func store<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E) throws {
        let data = try encoder.encode(value)
        try storage.store(value: data as! Data, key: key)
    }

    func store<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try encoder.encode(value)
                DispatchQueue.main.async {
                    storage.store(value: data as! Data, key: key) { result in
                        switch result {
                        case .success:
                            success?()
                        case .failure(let error):
                            failure?(error)
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }
    }

    func delete(key: String) throws {
        try storage.delete(key: key)
    }

    func buildFetchFuture<T: Decodable, D: TopLevelDecoder>(key: String, decoder: D) -> Future<T, Error> {
        Future<T, Error> { promise in
            fetch(key: key, decoder: decoder, success: { promise(.success($0)) }, failure: { promise(.failure($0))})
        }
    }

    func buildStoreFuture<T: Encodable, E: TopLevelEncoder>(value: T, key: String, encoder: E) -> Future<Void, Error> {
        Future<Void, Error> { promise in
            store(value: value, key: key, encoder: encoder, success: { promise(.success(())) }, failure: { promise(.failure($0)) })
        }
    }
}
