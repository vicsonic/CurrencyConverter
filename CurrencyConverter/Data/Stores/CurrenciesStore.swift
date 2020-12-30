//
//  CurrenciesStore.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation
import Combine

class CurrenciesStore: Store, StorageOwner {

    // MARK: - Store

    typealias T = Currencies
    private(set) var builder: PublisherBuilder

    // MARK: - Storage Owner

    private enum Constants {
        static let storageCurrenciesKey = "Currencies"
    }

    private(set) var storage: Storage
    private lazy var encoder: JSONEncoder = {
        JSONEncoder()
    }()
    private lazy var decoder: JSONDecoder = {
       JSONDecoder()
    }()

    // MARK: - Currencies

    private var currenciesPublisher: AnyPublisher<Currencies, Error>
    private var currenciesCancellable: AnyCancellable?

    func loadCurrencies(success: @escaping (Currencies) -> Void, failure: @escaping (Error) -> Void) {
        fetch(key: Constants.storageCurrenciesKey, decoder: decoder, success: success, failure: failure)
    }

    func saveCurrencies(_ currencies: Currencies) {
        store(value: currencies, key: Constants.storageCurrenciesKey, encoder: encoder, success: nil, failure: nil)
    }

    func deleteCurrencies() {
        try? delete(key: Constants.storageCurrenciesKey)
    }

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
        storage = AppSettings.shared.diskStorage
        currenciesPublisher = builder.publisher(for: CurrencyLayerRouter.list, decoder: JSONDecoder())
    }

    deinit {
        cancelGetCurrencies()
    }
}

// MARK: - Tests Setup

extension CurrenciesStore {
    func setForTests(router: Router) {
        currenciesPublisher = builder.publisher(for: router, decoder: decoder)
    }
}
