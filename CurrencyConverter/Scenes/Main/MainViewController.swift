//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var converterContainerView: UIView!
    
    private enum Constants {
        static let presentCurrenciesSegue = "presentCurrencies"
        static let cellIdentifier = "ConversionCell"
        static let headerIdentifier =  "ConverterView"
        static let headerHeight: CGFloat = 200
        static let collectionViewInset: CGFloat = 8
        static let collectionViewSpacing:  CGFloat = 2
        static let collectionViewSizeShinkrer: CGFloat = 10
        static let collectionViewColumns: CGFloat = 2
    }

    private lazy var viewModel = MainViewModel()
    private weak var converterViewController: ConverterViewController? {
        children.first as? ConverterViewController
    }
    private weak var refreshControl: UIRefreshControl?
    private weak var header: ConverterView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupStreams()
        setupEvents()
        setupStyle()

        showRefreshControl(true)
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

// MARK: - Actions

extension MainViewController {
    @objc
    private func onDidPullToRefresh(sender: Any) {
        viewModel.getData()
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
        layout.minimumLineSpacing = Constants.collectionViewSpacing
        layout.minimumInteritemSpacing = Constants.collectionViewSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.collectionViewInset, bottom: 0, right: Constants.collectionViewInset)
        let screen = UIScreen.main.bounds
        let size = (screen.width / Constants.collectionViewColumns) - Constants.collectionViewSizeShinkrer
        layout.itemSize = CGSize(width: size, height: size)
        layout.headerReferenceSize = CGSize(width: screen.width, height: Constants.headerHeight)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onDidPullToRefresh(sender:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        self.refreshControl = refreshControl
    }

    private func setupStreams() {
        viewModel.bindOnLoadingData { [weak self] loading in
            self?.showRefreshControl(loading)
        }

        viewModel.bindOnError { error in
            debugPrint(error.localizedDescription)
        }

        viewModel.bindOnDataLoaded { [weak self] (currencies, quotes) in
            guard let self = self else {
                return
            }
            self.converterViewController?.setupViewController(currencies: currencies, quotes: quotes)
            self.showInterface(true)
        }

        viewModel.bindOnDataUpdated { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setupHeader(using reusable: ConverterView) {
        guard header == nil else {
            return
        }
        reusable.addSubview(converterContainerView)
        converterContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            converterContainerView.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            converterContainerView.leadingAnchor.constraint(equalTo: reusable.leadingAnchor),
            converterContainerView.trailingAnchor.constraint(equalTo: reusable.trailingAnchor),
            converterContainerView.topAnchor.constraint(equalTo: reusable.topAnchor),
            converterContainerView.bottomAnchor.constraint(equalTo: reusable.bottomAnchor)
        ])
        header = reusable
    }

    private func setupEvents() {
        converterViewController?.onSelectCurrency { [weak self] (currencies, selected) in
            self?.performSegue(withIdentifier: Constants.presentCurrenciesSegue, sender: (currencies, selected))
        }

        converterViewController?.onConversionUpdated({ [weak self] conversion in
            self?.viewModel.updateData(using: conversion)
        })
    }

    private func setupStyle() {
        refreshControl?.setStyle(RefreshControlStyle())
    }
}

// MARK: - UI Handling

extension MainViewController {
    private func showInterface(_ show: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.converterViewController?.view.isHidden = !show
            self.collectionView.isHidden = !show
        }
    }

    private func showRefreshControl(_ show: Bool) {
        if show {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}

// MARK: - UICollectionView Handling

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfConversions()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let header = header {
            return header
        }
        guard kind == UICollectionView.elementKindSectionHeader,
              let reusable = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerIdentifier, for: indexPath) as? ConverterView else {
            return UICollectionReusableView()
        }
        setupHeader(using: reusable)
        return header ?? reusable
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ConversionCell,
              let conversion = viewModel.conversionAt(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setStyle(ConversionCellStyle())
        cell.update(using: conversion)
        return cell
    }
}

