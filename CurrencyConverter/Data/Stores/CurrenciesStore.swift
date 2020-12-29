//
//  CurrenciesStore.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation
import Combine

class CurrenciesStore: Store {

    // MARK: - Store

    typealias T = Currencies
    private(set) var builder: PublisherBuilder

    // MARK: - Settings

    private var currenciesPublisher: AnyPublisher<Currencies, Error>
    private var currenciesCancellable: AnyCancellable?

    func getCurrencies(success: @escaping (Currencies) -> Void, failure: @escaping (Error) -> Void) {
        guard currenciesCancellable == nil else {
            DispatchQueue.main.async {
                failure(CurrencyConverterError.Store.existingCancellableForRequest)
            }
            return
        }
        currenciesCancellable = currenciesPublisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            case .finished:
                debugPrint("Publisher: \(#function) completed")
            }
            self?.currenciesCancellable = nil
        }, receiveValue: { currencies in
            DispatchQueue.main.async {
                success(currencies)
            }
        })
    }

    func cancelGetCurrencies() {
        currenciesCancellable?.cancel()
        currenciesCancellable = nil
    }

    // MARK: - Lifecycle

    init() {
        builder = PublisherBuilder()
        currenciesPublisher = builder.publisher(for: CurrencyLayerRouter.list, decoder: JSONDecoder())
    }

    deinit {
        cancelGetCurrencies()
    }
}

// MARK: - Tests Setup

extension CurrenciesStore {
    func setForTests(router: Router) {
        currenciesPublisher = builder.publisher(for: router, decoder: JSONDecoder())
    }
}
