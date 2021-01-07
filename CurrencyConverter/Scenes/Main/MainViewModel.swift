//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

class MainViewModel {

    private lazy var interactor = MainInteractor()

    func loadData() {
        interactor.loadData()
    }

    func getData() {
        interactor.getData()
    }

    func bindOnLoadingData(_ observer: @escaping (Bool) -> Void) {
        interactor.onLoadingDataBindable.bind(observer)
    }

    func bindOnError(_ observer: @escaping (Error) -> Void) {
        interactor.onErrorBindable.bind(observer)
    }

    func bindOnDataLoaded(_ observer: @escaping (Currencies, Quotes) -> Void) {
        interactor.onDataLoadedBindable.bind(observer)
    }

    func bindOnDataUpdated(_ observer: @escaping () -> Void) {
        interactor.onDataUpdatedBindable.bind(observer)
    }

    func updateData(using conversion: Conversion) {
        interactor.updateData(using: conversion)
    }

    func numberOfConversions() -> Int {
        return interactor.results?.count ?? 0
    }

    func conversionAt(indexPath: IndexPath) -> ConversionResult? {
        return interactor.results?[indexPath.row]
    }
}
