//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class ConverterViewModel {

    private var interactor: ConverterInteractor!

    func setUsing(currencies: Currencies, quotes: Quotes) {
        self.interactor = ConverterInteractor(currencies: currencies, quotes: quotes)
    }

    func bindOnLastUpdate(_ observer: @escaping (String) -> Void) {
        interactor.lastUpdateBindable.bindAndFire(observer)
    }

    func bindOnSelectedCurrency(_ observer: @escaping (Currency) -> Void) {
        interactor.selectedCurrencyBindable.bindAndFire(observer)
    }

    func bindOnConversionUpdated(_ observer: @escaping (Conversion) -> Void) {
        interactor.conversionBindable.bindAndFire(observer)
    }

    func updateAmount(_ amount: String) {
        interactor.updateConversion(amount: amount)
    }

    func updateSelectedCurrency(_ selected: Currency) {
        interactor.updateConversion(selectedCurrency: selected)
    }

    func currencies() -> Currencies {
        interactor.currencies
    }

    func selectedCurrency() -> Currency {
        interactor.selectedCurrency
    }
}
