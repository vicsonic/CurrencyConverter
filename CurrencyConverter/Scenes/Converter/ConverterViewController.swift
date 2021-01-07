//
//  ConverterViewController.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import UIKit
import Combine

class ConverterViewController: UITableViewController, UITextFieldDelegate, BindableUpdater {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currencyCell: CurrencyCell!
    private weak var footer: UITableViewHeaderFooterView? {
        tableView.footerView(forSection: 0)
    }
    
    private enum Constants {
        static let currencyIndex = 1
    }

    private var cancelBag = Set<AnyCancellable>()
    private lazy var viewModel = ConverterViewModel()
    private lazy var onSelectCurrencyBindable = Bindable((Currencies(), Currency()))
    private lazy var onConversionUpdatedBindable = Bindable(Conversion())

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    deinit {
        onSelectCurrencyBindable.invalidate()
        onConversionUpdatedBindable.invalidate()
    }
}

// MARK: - Setup

extension ConverterViewController {
    func setupViewController(currencies: Currencies, quotes: Quotes) {
        viewModel.setupUsing(currencies: currencies, quotes: quotes)
        setupStreams()
        setupInitialValues()
    }

    private func setupViewController() {
        setupTableView()
        setupTextField()
        setupStyle()
    }

    private func setupTableView() {
        tableView.sectionHeaderHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
    }

    private func setupTextField() {
        textField.keyboardType = .numbersAndPunctuation
        textField.placeholder = "Type the quantity"
        textField.returnKeyType = .done
    }

    private func setupInitialValues() {
        textField.text = "1"
        textField.sendActions(for: .editingChanged)
    }

    private func setupStreams() {
        viewModel.bindOnLastUpdate { [weak self]  lastUpdate in
            self?.updateLastUpdate(lastUpdate)
        }

        viewModel.bindOnSelectedCurrency { [weak self] currency in
            self?.updateSelectedCurrency(currency)
        }

        viewModel.bindOnConversionUpdated { [weak self] conversion in
            guard let self = self else {
                return
            }
            self.handleBindableUpdate(self.onConversionUpdatedBindable, value: conversion)
        }

        textField.publisher.sink { [weak self] amount in
            self?.viewModel.updateAmount(amount)
        }.store(in: &cancelBag)
    }

    private func setupStyle() {
        textField.setStyle(TextFieldStyle())
        currencyCell.setStyle(TableCellStyle())
        footer?.setStyle(FooterStyle())
    }
}

// MARK: - UITextFieldDelegate

extension ConverterViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.shouldChangeCharactersIn(range: range, originalString: textField.text, replacementString: string, validation: .decimalNumber)
    }
}

// MARK: - UI

extension ConverterViewController {
    private func updateLastUpdate(_ value: String) {
        tableView.beginUpdates()
        footer?.textLabel?.text = "Last Update: \(value)"
        footer?.sizeToFit()
        tableView.endUpdates()
    }

    private func updateSelectedCurrency(_ currency: Currency) {
        tableView.beginUpdates()
        currencyCell.update(using: currency)
        tableView.endUpdates()
    }
}

// MARK: - Actions

extension ConverterViewController {
    func onSelectCurrency(_ observer: @escaping (Currencies, Currency) -> Void) {
        onSelectCurrencyBindable.bind(observer)
    }

    func onConversionUpdated(_ observer: @escaping (Conversion) -> Void) {
        onConversionUpdatedBindable.bind(observer)
    }

    func currencySelected(_ currency: Currency) {
        viewModel.updateSelectedCurrency(currency)
    }
}

// MARK: - UITableViewDelegate

extension ConverterViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == Constants.currencyIndex else {
            return
        }
        handleBindableUpdate(onSelectCurrencyBindable, value: (viewModel.currencies(), viewModel.selectedCurrency()))
    }
}
