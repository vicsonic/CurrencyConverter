//
//  QuotesStore.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation
import Combine

class QuotesStore: Store {

    // MARK: - Store

    typealias T = Quotes
    private(set) var builder: PublisherBuilder

    // MARK: - Settings

    private var quotesPublisher: AnyPublisher<Quotes, Error>
    private var quotesCancellable: AnyCancellable?

    func getQuotes(success: @escaping (Quotes) -> Void, failure: @escaping (Error) -> Void) {
        guard quotesCancellable == nil else {
            DispatchQueue.main.async {
                failure(CurrencyConverterError.Store.existingCancellableForRequest)
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
        quotesPublisher = builder.publisher(for: CurrencyLayerRouter.live, decoder: JSONDecoder())
    }

    deinit {
        cancelGetQuotes()
    }
}

// MARK: - Tests Setup

extension QuotesStore {
    func setForTests(router: Router) {
        quotesPublisher = builder.publisher(for: router, decoder: JSONDecoder())
    }
}
