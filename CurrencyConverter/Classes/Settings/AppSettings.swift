//
//  AppSettings.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 29/12/20.
//

import Foundation

class AppSettings {

    private(set) var apiSettings: APISettings?
    private var apiSettingsStore: APISettingsStore

    static let shared = AppSettings()

    // MARK: - Lifecycle

    init() {
        apiSettingsStore = APISettingsStore()
    }

    // MARK: - Public
    
    private func load(completion: (() -> Void)?) {
        apiSettingsStore.getAPISettings(success: { [weak self] apiSettings in
            self?.apiSettings = apiSettings
            completion?()
        }, failure: { [weak self] error in
            self?.apiSettings = nil
            completion?()
        })
    }

    // MARK: - Static

    static func load(completion: (() -> Void)? = nil) {
        shared.load(completion: completion)
    }

    static func dispose() {
        shared.apiSettings = nil
    }
}
