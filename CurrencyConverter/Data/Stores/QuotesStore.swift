//
//  QuotesStore.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation
import Combine

class QuotesStore: Store, StorageOwner {

    // MARK: - Store

    typealias T = Quotes
    private(set) var builder: PublisherBuilder

    // MARK: - Storage Owner

    private enum Constants {
        static let storageQuotesKey = "Quotes"
    }

    private(set) var storage: Storage
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()

    // MARK: - Quotes

    private lazy var quotesPublisher: AnyPublisher<Quotes, Error> = {
        buildQuotesPublisher()
    }()
    private var quotesCancellable: AnyCancellable?

    func loadQuotes(success: @escaping (Quotes) -> Void, failure: @escaping (Error) -> Void) {
        fetch(key: Constants.storageQuotesKey, decoder: decoder, success: success, failure: failure)
    }

    func saveQuotes(_ quotes: Quotes) {
        store(value: quotes, key: Constants.storageQuotesKey, encoder: encoder, success: nil, failure: nil)
    }

    func deleteQuotes() {
        try? delete(key: Constants.storageQuotesKey)
    }

    func buildQuotesPublisher() -> AnyPublisher<Quotes, Error> {
        builder.publisher(for: CurrencyLayerRouter.live, decoder: decoder)
    }

    func buildLoadFuture() -> Future<Quotes, Error> {
        buildFetchFuture(key: Constants.storageQuotesKey, decoder: decoder)
    }

    func getQuotes(success: @escaping (Quotes) -> Void, failure: @escaping (Error) -> Void) {
        guard quotesCancellable == nil else {
            DispatchQueue.main.async {
                failure(AppError.Store.existingCancellableForRequest)
            }
            return
        }
        quotesCancellable = quotesPublisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            case .finished:
                debugPrint("Publisher: \(#function) completed")
            }
            self?.quotesCancellable = nil
        }, receiveValue: { quotes in
            DispatchQueue.main.async {
                success(quotes)
            }
        })
    }

    func cancelGetQuotes() {
        quotesCancellable?.cancel()
        quotesCancellable = nil
    }

    // MARK: - Lifecycle

    init() {
        builder = PublisherBuilder()
        storage = AppSettings.shared.diskStorage
    }

    deinit {
        cancelGetQuotes()
    }
}

// MARK: - Tests Setup

extension QuotesStore {
    func setForTests(router: Router) {
        quotesPublisher = builder.publisher(for: router, decoder: decoder)
    }
}
