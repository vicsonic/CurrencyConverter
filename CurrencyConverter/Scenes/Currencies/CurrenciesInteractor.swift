//
//  CurrenciesInteractor.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class CurrenciesInteractor: BindableUpdater {

    private(set) var currencies: [Currency] = []
    private(set) var selectedCurrency = Currency() {
        didSet {
            handleBindableUpdate(onCurrencySelectedBindable, value: selectedCurrency)
        }
    }

    // MARK: - Bindables

    private(set) var onDataUpdatedBindable = Bindable(())
    private(set) var onCurrencySelectedBindable = Bindable(Currency())

    // MARK: - Setup

    func setupInteractor(currencies: Currencies, selected: Currency) {
        self.currencies = currencies.currencies.sorted(by: { $0.code > $1.code })
        updateSelectedCurrency(selected)
        handleBindableUpdate(onDataUpdatedBindable, value: ())
    }

    // MARK: - Update

    func updateSelectedCurrency(_ currency: Currency) {
        self.selectedCurrency = currency
    }
}
