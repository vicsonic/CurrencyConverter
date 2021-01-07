//
//  MainInteractor.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation
import Combine

class MainInteractor: BindableUpdater {

    private lazy var currenciesStore = CurrenciesStore()
    private lazy var quotesStore = QuotesStore()

    private var loadCancellable: AnyCancellable?
    private var getCancellable: AnyCancellable?

    private var currencies: Currencies?
    private var quotes: Quotes?
    private(set) var conversion: Conversion? {
        didSet {
            results = conversion?.results.map{ $1 }.sorted(by: { $0.currency.code > $1.currency.code })
            handleBindableUpdate(onDataUpdatedBindable, value: ())
        }
    }
    private(set) var results: [ConversionResult]?

    // MARK: - Bindables

    private(set) var onLoadingDataBindable: Bindable<Bool>
    private(set) var onErrorBindable: Bindable<Error>
    private(set) var onDataLoadedBindable: Bindable<(Currencies, Quotes)>
    private(set) var onDataUpdatedBindable: Bindable<Void>

    // MARK: - Lifecycle

    init() {
        self.onLoadingDataBindable = Bindable(false)
        self.onDataLoadedBindable = Bindable((Currencies(), Quotes()))
        self.onErrorBindable = Bindable(AppError.Bindable.unknown)
        self.onDataUpdatedBindable = Bindable(())
    }

    deinit {
        currencies = nil
        quotes = nil
        conversion = nil
        results = nil
    }

    // MARK: - Data Functions

    func loadData() {
        AppSettings.load { [weak self] in
            self?.loadStoredData()
        }
    }

    func getData() {
        loadingData(true)
        getCancellable = Publishers.Zip(currenciesStore.buildCurrenciesPublisher(), quotesStore.buildQuotesPublisher())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    debugPrint("Interactor: \(#function) completed")
                case .failure(let error):
                    self.handleError(error)
                    debugPrint(error.localizedDescription)
                }
                self.loadingData(false)
            }, receiveValue: { [weak self] (currencies, quotes) in
                guard let self = self else {
                    return
                }
                self.currencies = currencies
                self.quotes = quotes
                self.dataLoaded(currencies: currencies, quotes: quotes)
            })
    }

    private func loadStoredData() {
        loadingData(true)
        loadCancellable = Publishers.Zip(currenciesStore.buildLoadFuture(), quotesStore.buildLoadFuture())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .finished:
                    debugPrint("Interactor: \(#function) completed")
                case .failure(let error):
                    self.handleError(error)
                    debugPrint(error.localizedDescription)
                }
                self.loadingData(false)
                self.getData()
            }, receiveValue: { [weak self] (currencies, quotes) in
                guard let self = self else {
                    return
                }
                self.currencies = currencies
                self.quotes = quotes
                self.saveData()
                self.dataLoaded(currencies: currencies, quotes: quotes)
            })
    }

    private func saveData() {
        if let currencies = currencies {
            currenciesStore.saveCurrencies(currencies)
        }
        if let quotes = quotes {
            quotesStore.saveQuotes(quotes)
        }
    }

    private func loadingData(_ value: Bool) {
        handleBindableUpdate(onLoadingDataBindable, value: value)
    }

    private func handleError(_ error: Error) {
        handleBindableUpdate(onErrorBindable, value: error)
    }

    private func dataLoaded(currencies: Currencies, quotes: Quotes) {
        handleBindableUpdate(onDataLoadedBindable, value: (currencies, quotes))
    }

    // MARK: - Update

    func updateData(using conversion: Conversion) {
        self.conversion = conversion
    }
}
