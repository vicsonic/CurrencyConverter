//
//  CurrenciesTests.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 28/12/20.
//

import XCTest
import Combine

class CurrenciesTests: XCTestCase {

    var localStore: CurrenciesStore!
    var localCurrencies: Currencies?
    let localCurrenciesCount = 168

    var remoteStore: CurrenciesStore!
    var remoteCurrencies: Currencies?

    let currenciesStorageKey = "Currencies"
    var savedCurrencies: Currencies?

    override func setUpWithError() throws {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        localStore = CurrenciesStore()
        localStore.setForTests(router: CurrencyLayerTestRouter.list)
        AppSettings.load { [weak self] in
            self?.remoteStore = CurrenciesStore()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    override func tearDownWithError() throws {
        localStore.cancelGetCurrencies()
        localCurrencies = nil
        remoteStore.cancelGetCurrencies()
        remoteCurrencies = nil
        savedCurrencies = nil
        AppSettings.dispose()
    }

    func testLocalLoad() throws {
        let expectation = self.expectation(description: "Local currencies loaded")
        localStore.getCurrencies(success: { [weak self] currencies in
            self?.localCurrencies = currencies
            expectation.fulfill()
            debugPrint("Local currencies loaded: \(currencies)")
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(localCurrencies, "Local currencies not loaded")
        XCTAssertEqual(localCurrencies?.currencies.count, localCurrenciesCount)
    }

    func testRemoteLoad() throws {
        let expectation = self.expectation(description: "Remote currencies loaded")
        remoteStore.getCurrencies(success: { [weak self] currencies in
            self?.remoteCurrencies = currencies
            expectation.fulfill()
            debugPrint("Remote currencies loaded: \(currencies)")
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [expectation], timeout: 15)
        XCTAssertNotNil(remoteCurrencies, "Remote currencies not loaded")
        XCTAssertTrue(remoteCurrencies!.currencies.count > 0, "Does not exist currencies in remote response")
    }

    func testStorageSave() {
        var currenciesLoaded: Currencies?
        let expectation = self.expectation(description: "Currencies saved")
        remoteStore.getCurrencies(success: { [weak self] currencies in
            guard let self = self else { return }
            do {
                currenciesLoaded = currencies
                try self.remoteStore.store(value: currencies, key: self.currenciesStorageKey, encoder: JSONEncoder())
                self.savedCurrencies = try self.remoteStore.fetch(key: self.currenciesStorageKey, decoder: JSONDecoder())
                expectation.fulfill()
                debugPrint("Currencies saved: \(currencies)")
            } catch {
                debugPrint(error)
            }
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [expectation], timeout: 15)
        XCTAssertNotNil(savedCurrencies, "Currencies not saved")
        XCTAssertEqual(currenciesLoaded?.currencies.count, savedCurrencies?.currencies.count)
    }
}
