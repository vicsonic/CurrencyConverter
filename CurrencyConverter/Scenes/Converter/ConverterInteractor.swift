//
//  ConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class ConverterInteractor: BindableUpdater {

    enum Constants {
        static let defaultCurrencyCode = "USD"
    }

    private(set) var currencies: Currencies
    private var quotes: Quotes
    private var converter: Converter

    private(set) var lastUpdateBindable = Bindable(String())
    private(set) var selectedCurrencyBindable = Bindable(Currency())
    private(set) var conversionBindable = Bindable(Conversion())

    private var amount: Double {
        didSet {
            updateConversion()
        }
    }
    private(set) var selectedCurrency: Currency {
        didSet {
            handleBindableUpdate(selectedCurrencyBindable, value: selectedCurrency)
            updateConversion()
        }
    }
    private var conversion: Conversion {
        didSet {
            handleBindableUpdate(conversionBindable, value: conversion)
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()

    // MARK: - Lifecycle

    init(currencies: Currencies, quotes: Quotes) {
        self.currencies = currencies
        self.quotes = quotes
        self.converter = Converter(currencies: currencies, quotes: quotes)
        self.selectedCurrency = Currency()
        self.conversion = Conversion()
        self.amount = 1

        setupInteractor()
    }

    // MARK: - Setup

    private func setupInteractor() {
        handleBindableUpdate(lastUpdateBindable, value: dateFormatter.string(from: quotes.timestamp))
        if let selectedCurrency = converter.currenciesCatalog[Constants.defaultCurrencyCode] {
            updateConversion(selectedCurrency: selectedCurrency)
        }
    }

    // MARK: - Update

    func updateConversion(amount: String) {
        self.amount = Double(amount) ?? 0
    }

    func updateConversion(selectedCurrency: Currency) {
        self.selectedCurrency = selectedCurrency
    }

    private func updateConversion() {
        self.conversion = converter.convert(source: selectedCurrency, value: amount) ?? Conversion()
    }
}
