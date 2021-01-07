//
//  CurrenciesViewModel.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class CurrenciesViewModel {

    private lazy var interactor = CurrenciesInteractor()

    // MARK: - Setup

    func setupUsing(currencies: Currencies, selected: Currency) {
        interactor.setupInteractor(currencies: currencies, selected: selected)
    }

    // MARK: - Bindings

    func bindOnDataUpdated(_ observer: @escaping () -> Void) {
        interactor.onDataUpdatedBindable.bind(observer)
    }

    func bindOnCurrencySelected(_ observer: @escaping (Currency) -> Void) {
        interactor.onCurrencySelectedBindable.bind(observer)
    }

    // MARK: - Update

    func updateSelectedCurrency(_ currency: Currency) {
        interactor.updateSelectedCurrency(currency)
    }

    func isSelected(currency: Currency) -> Bool {
        currency == selectedCurrency()
    }

    // MARK: - Data Source

    func selectedCurrency() -> Currency {
        interactor.selectedCurrency
    }

    func numberOfSections() -> Int {
        1
    }

    func numberOfCurrencies() -> Int {
        interactor.currencies.count
    }

    func currency(at indexPath: IndexPath) -> Currency {
        interactor.currencies[indexPath.row]
    }
}
