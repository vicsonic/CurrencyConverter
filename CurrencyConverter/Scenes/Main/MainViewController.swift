//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private enum Constants {
        static let presentCurrenciesSegue = "presentCurrencies"
        static let cellIdentifier = "ConversionCell"
    }

    private lazy var viewModel = MainViewModel()
    private lazy var converterViewController: ConverterViewController? = {
        children.first as? ConverterViewController
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupStyle()
        setupStreams()
        setupEvents()
    
        viewModel.loadData()
    }
}

// MARK: - Navigation

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier,
              segueIdentifier == Constants.presentCurrenciesSegue,
              let navigation = segue.destination as? UINavigationController,
              let currenciesViewController = navigation.topViewController as? CurrenciesViewController,
              let (currencies, selected) = sender as? (Currencies, Currency) else {
            return
        }
        currenciesViewController.setupViewController(currencies: currencies, selected: selected)
        currenciesViewController.onCurrencySelected { [weak self] currency in
            self?.converterViewController?.currencySelected(currency)
        }
    }
}

// MARK: - Setup

extension MainViewController {

    private func setupViewController() {
        title = "Currency Converter"
        showInterface(false)
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let size = (UIScreen.main.bounds.width / 3) - 7
        layout.itemSize = CGSize(width: size, height: size)
        collectionView.collectionViewLayout = layout
    }

    private func setupStyle() {
        
    }

    private func setupStreams() {
        viewModel.bindOnLoadingData { loading in
            debugPrint("Loading: \(loading)")
        }

        viewModel.bindOnError { error in
            debugPrint(error.localizedDescription)
        }

        viewModel.bindOnDataLoaded { [weak self] (currencies, quotes) in
            guard let self = self else {
                return
            }
            self.converterViewController?.setViewController(currencies: currencies, quotes: quotes)
            self.showInterface(true)
        }

        viewModel.bindOnDataUpdated { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setupEvents() {
        converterViewController?.onSelectCurrency { [weak self] (currencies, selected) in
            self?.performSegue(withIdentifier: Constants.presentCurrenciesSegue, sender: (currencies, selected))
        }

        converterViewController?.onConversionUpdated({ [weak self] conversion in
            self?.viewModel.updateData(using: conversion)
        })
    }
}

// MARK: - UI Handling

extension MainViewController {
    private func showInterface(_ show: Bool) {
        converterViewController?.view.isHidden = !show
        collectionView.isHidden = !show
    }
}

// MARK: - UICollectionView Handling

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfConversions()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ConversionCell,
              let conversion = viewModel.conversionAt(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.update(using: conversion)
        return cell
    }
}

