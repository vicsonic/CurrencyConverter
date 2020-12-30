//
//  APISettingsTests.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 28/12/20.
//

import XCTest
import Combine

class APISettingsTests: XCTestCase {

    var store: APISettingsStore!
    var settings: APISettings?
    let apiKeyLength = 32

    override func setUpWithError() throws {
        store = APISettingsStore()
    }

    override func tearDownWithError() throws {
        store.cancelGetAPISettings()
        settings = nil
    }

    func testLoad() throws {
        let expectation = self.expectation(description: "Settings loaded")
        store.getAPISettings { [weak self] settings in
            self?.settings = settings
            expectation.fulfill()
            debugPrint("Settings Loaded: \(settings)")
        } failure: { error in
            debugPrint(error)
        }
        wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(settings, "Settings not loaded")
        XCTAssertNotNil(settings?.baseURL, "Base url not loaded")
        XCTAssertNotNil(settings?.apiKey, "API key not loaded")
        XCTAssertEqual(settings?.apiKey.count, apiKeyLength)
    }
}
