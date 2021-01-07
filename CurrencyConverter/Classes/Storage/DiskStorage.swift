//
//  DiskStorage.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

class DiskStorage {
    private let queue: DispatchQueue
    private let manager: FileManager
    private let path: URL

    // MARK: - Lifecycle

    init(queue: DispatchQueue = .init(label: "DiskStorage.Queue"), manager: FileManager = .default, path: URL) {
        self.queue = queue
        self.manager = manager
        self.path = path
    }

    // MARK: - Directory

    private func createDirectoryIfNeeded(url: URL) throws {
        let directoryURL = url.deletingLastPathComponent()
        guard !manager.fileExists(atPath: directoryURL.path) else {
            return
        }
        try manager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
    }
}

// MARK: - ReadStorage

extension DiskStorage: ReadStorage {
    func fetchData(key: String) throws -> Data {
        let url = path.appendingPathComponent(key)
        guard let data = manager.contents(atPath: url.path) else {
            throw AppError.Storage.fileNotFound
        }
        return data
    }

    func fetchData(key: String, completion: ((Result<Data, Error>) -> Void)?) {
        queue.async {
            let result = Result { try self.fetchData(key: key) }
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
}

// MARK: - WriteStorage

extension DiskStorage: WriteStorage {
    func store(value: Data, key: String) throws {
        let url = path.appendingPathComponent(key)
        do {
            try self.createDirectoryIfNeeded(url: url)
            try value.write(to: url, options: .atomic)
        } catch {
            throw AppError.Storage.write(error: error)
        }
    }

    func store(value: Data, key: String, completion: ((Result<Bool, Error>) -> Void)?) {
        queue.async {
            do {
                try self.store(value: value, key: key)
                DispatchQueue.main.async {
                    completion?(.success(true))
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
    }
}

// MARK: - Delete Storage

extension DiskStorage: DeleteStorage {
    func delete(key: String) throws {
        let url = path.appendingPathComponent(key)
        try manager.removeItem(at: url)
    }
}
