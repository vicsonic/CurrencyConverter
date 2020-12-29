//
//  QuotesTests.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 29/12/20.
//

import XCTest
import Combine

class QuotesTests: XCTestCase {

    var localStore: QuotesStore!
    var localQuotes: Quotes?
    let localQuotesCount = 168

    var remoteStore: QuotesStore!
    var remoteQuotes: Quotes?

    override func setUpWithError() throws {
        let expectation = self.expectation(description: "\(#function)\(#line)")
        localStore = QuotesStore()
        localStore.setForTests(router: CurrencyLayerTestRouter.live)
        AppSettings.load { [weak self] in
            self?.remoteStore = QuotesStore()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    override func tearDownWithError() throws {
        localStore.cancelGetQuotes()
        localQuotes = nil
        remoteStore.cancelGetQuotes()
        remoteQuotes = nil
        AppSettings.dispose()
    }

    func testLocalLoad() throws {
        let expectation = self.expectation(description: "Local quotes loaded")
        localStore.getQuotes(success: { [weak self] quotes in
            self?.localQuotes = quotes
            expectation.fulfill()
            debugPrint("Local quotes loaded: \(quotes)")
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertNotNil(localQuotes, "Local quotes not loaded")
        XCTAssertEqual(localQuotes?.quotes.count, localQuotesCount)
    }

    func testRemoteLoad() throws {
        let expectation = self.expectation(description: "Remote quotes loaded")
        remoteStore.getQuotes(success: { [weak self] quotes in
            self?.remoteQuotes = quotes
            expectation.fulfill()
            debugPrint("Remote quotes loaded: \(quotes)")
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [expectation], timeout: 15)
        XCTAssertNotNil(remoteQuotes, "Remote quotes not loaded")
        XCTAssertTrue(remoteQuotes!.quotes.count > 0, "Does not exist quotes in remote response")
    }
}
