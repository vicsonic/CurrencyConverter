//
//  CurrenciesInteractor.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class CurrenciesInteractor: BindableUpdater {

    private(set) var onDataUpdatedBindable = Bindable(())
    private(set) var onCurrencySelectedBindable = Bindable(Currency())

    private(set) var currencies: [Currency] = []
    private(set) var selectedCurrency = Currency() {
        didSet {
            handleBindableUpdate(onCurrencySelectedBindable, value: selectedCurrency)
        }
    }

    func setupInteractor(currencies: Currencies, selected: Currency) {
        self.currencies = currencies.currencies.sorted(by: { $0.code > $1.code })
        updateSelectedCurrency(selected)
        handleBindableUpdate(onDataUpdatedBindable, value: ())
    }

    func updateSelectedCurrency(_ currency: Currency) {
        self.selectedCurrency = currency
    }

}
