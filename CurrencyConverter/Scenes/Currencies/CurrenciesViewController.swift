//
//  CurrenciesViewController.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import UIKit

class CurrenciesViewController: UITableViewController, BindableUpdater {

    private enum Constants {
        static let cellIdentifier = "CurrencyCell"
    }

    private lazy var viewModel = CurrenciesViewModel()
    private lazy var onCurrencySelectedBindable = Bindable(Currency())

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }

    // MARK: - Actions

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func onCurrencySelected(_ observer: @escaping (Currency) -> Void) {
        onCurrencySelectedBindable.bind(observer)
    }
}

// MARK: - Setup

extension CurrenciesViewController {
    func setupViewController(currencies: Currencies, selected: Currency) {
        viewModel.setUsing(currencies: currencies, selected: selected)
        setupStreams()
    }

    private func setupViewController() {
        title = "Select Currency"
    }

    private func setupStreams() {
        viewModel.bindOnDataUpdated { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.bindOnCurrencySelected { [weak self] currency in
            guard let self = self else {
                return
            }
            self.tableView.reloadSections([0], with: .automatic)
            self.handleBindableUpdate(self.onCurrencySelectedBindable, value: currency)
        }
    }
}

// MARK: - UITableView Handling

extension CurrenciesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCurrencies()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }
        let currency = viewModel.currency(at: indexPath)
        cell.update(using: currency)
        cell.updateAccessoryType(selected: viewModel.isSelected(currency: currency))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateSelectedCurrency(viewModel.currency(at: indexPath))
        dismiss(animated: true, completion: nil)
    }
}
