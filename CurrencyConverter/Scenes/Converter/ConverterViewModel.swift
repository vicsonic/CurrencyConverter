//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class ConverterViewModel {

    private var interactor: ConverterInteractor!

    // MARK: - Setup

    func setupUsing(currencies: Currencies, quotes: Quotes) {
        self.interactor = ConverterInteractor(currencies: currencies, quotes: quotes)
    }

    // MARK: - Bindings

    func bindOnLastUpdate(_ observer: @escaping (String) -> Void) {
        interactor.lastUpdateBindable.bindAndFire(observer)
    }

    func bindOnSelectedCurrency(_ observer: @escaping (Currency) -> Void) {
        interactor.selectedCurrencyBindable.bindAndFire(observer)
    }

    func bindOnConversionUpdated(_ observer: @escaping (Conversion) -> Void) {
        interactor.conversionBindable.bindAndFire(observer)
    }

    // MARK: - Update

    func updateAmount(_ amount: String) {
        interactor.updateConversion(amount: amount)
    }

    func updateSelectedCurrency(_ selected: Currency) {
        interactor.updateConversion(selectedCurrency: selected)
    }

    // MARK: - Data Source

    func currencies() -> Currencies {
        interactor.currencies
    }

    func selectedCurrency() -> Currency {
        interactor.selectedCurrency
    }
}
