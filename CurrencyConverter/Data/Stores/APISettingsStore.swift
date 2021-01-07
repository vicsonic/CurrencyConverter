//
//  APISettingsStore.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation
import Combine

class APISettingsStore: Store {

    // MARK: - Store

    typealias T = APISettings
    private(set) var builder: PublisherBuilder

    // MARK: - APISettings

    private var apiSettingsPublisher: AnyPublisher<APISettings, Error>
    private var apiSettingsCancellable: AnyCancellable?

    func getAPISettings(success: @escaping (APISettings) -> Void, failure: @escaping (Error) -> Void) {
        guard apiSettingsCancellable == nil else {
            DispatchQueue.main.async {
                failure(AppError.Store.existingCancellableForRequest)
            }
            return
        }
        apiSettingsCancellable = apiSettingsPublisher.sink(receiveCompletion: { [weak self] completion in
            switch completion {
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            case .finished:
                debugPrint("Publisher: \(#function) completed")
            }
            self?.apiSettingsCancellable = nil
        }, receiveValue: { apiSettings in
            DispatchQueue.main.async {
                success(apiSettings)
            }
        })
    }

    func cancelGetAPISettings() {
        apiSettingsCancellable?.cancel()
        apiSettingsCancellable = nil
    }

    // MARK: - Lifecycle

    init() {
        builder = PublisherBuilder()
        apiSettingsPublisher = builder.publisher(for: APISettingsRouter(), decoder: PropertyListDecoder())
    }

    deinit {
        cancelGetAPISettings()
    }
}
