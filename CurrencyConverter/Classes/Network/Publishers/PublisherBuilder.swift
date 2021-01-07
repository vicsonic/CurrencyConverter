//
//  PublisherBuilder.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 28/12/20.
//

import Foundation
import Combine

class PublisherBuilder {
    func publisher<T: Codable, D: TopLevelDecoder>(for router: Router, decoder: D) -> AnyPublisher<T, Error> {
        guard var url = router.url else {
            return Fail(error: AppError.Router.invalidURL).eraseToAnyPublisher()
        }
        if case let AuthenticationType.url(name) = router.authenticationType,
           let authenticationKey = router.authenticationKey,
           let authURL = URL(string: url.absoluteString + "?\(name)=\(authenticationKey)") {
            url = authURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = router.method.rawValue
        if case let AuthenticationType.header(name: name) = router.authenticationType {
            request.setValue(router.authenticationKey, forHTTPHeaderField: name)
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data as! D.Input }
            .decode(type: T.self, decoder: decoder)
            .mapError({ error -> AppError.Publisher in
                return AppError.Publisher.request(error: error)
            })
            .retry(3)
            .eraseToAnyPublisher()
    }
}
