//
//  Bindable.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

final class Bindable<Value> {
    typealias Observer = (Value) -> Void

    private var observer: Observer?

    func bind(_ observer: Observer?) {
        self.observer = observer
    }

    func bindAndFire(_ observer: Observer?) {
        self.observer = observer
        self.observer?(value)
    }

    func invalidate() {
        self.observer = nil
    }

    fileprivate(set) var value: Value {
        didSet {
            observer?(value)
        }
    }

    init(_ value: Value) {
        self.value = value
    }

    deinit {
        invalidate()
    }
}

protocol BindableUpdater {
    func update<Value>(_ bindable: Bindable<Value>, value: Value)
}

extension BindableUpdater {
    func update<Value>(_ bindable: Bindable<Value>, value: Value) {
        DispatchQueue.main.async {
            bindable.value = value
        }
    }
}

extension BindableUpdater {
    func handleBindableUpdate<Value>(_ bindable: Bindable<Value>?, value: Value?) {
        guard let bindable = bindable, let value = value else {
            return
        }
        update(bindable, value: value)
    }
}
