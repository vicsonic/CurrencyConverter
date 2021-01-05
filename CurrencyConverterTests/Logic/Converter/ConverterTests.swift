//
//  ConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Victor Soto on 04/01/21.
//

import XCTest

class ConverterTests: XCTestCase {

    var currenciesStore: CurrenciesStore!
    var currencies: Currencies?
    var quotesStore: QuotesStore!
    var quotes: Quotes?

    let usd = "USD"
    let mxn = "MXN"
    let jpy = "JPY"

    let mxnToUSDResult: Double = 0.05
    let mxnToJPYResult: Double = 5.2

    let fiveTimesFactor: Double = 5
    let mxnToUSDFiveTimesResult: Double = 0.25
    let mxnToJPYFiveTimesResult: Double = 25.99

    override func setUpWithError() throws {
        let currenciesExpectation = self.expectation(description: "Currencies")
        currenciesStore = CurrenciesStore()
        currenciesStore.setForTests(router: CurrencyLayerTestRouter.list)
        currenciesStore.getCurrencies(success: { [weak self] currencies in
            self?.currencies = currencies
            currenciesExpectation.fulfill()
            debugPrint("Local currencies loaded: \(currencies)")
        }, failure: { error in
            debugPrint(error)
        })
        let quotesExpectation = self.expectation(description: "Quotes")
        quotesStore = QuotesStore()
        quotesStore.setForTests(router: CurrencyLayerTestRouter.live)
        quotesStore.getQuotes(success: { [weak self] quotes in
            self?.quotes = quotes
            quotesExpectation.fulfill()
            debugPrint("Local quotes loaded: \(quotes)")
        }, failure: { error in
            debugPrint(error)
        })
        wait(for: [currenciesExpectation, quotesExpectation], timeout: 10.0, enforceOrder: true)
    }

    override func tearDownWithError() throws {
        currenciesStore.cancelGetCurrencies()
        currencies = nil
        quotesStore.cancelGetQuotes()
        quotes = nil
    }

    func testUnitaryConversion() throws {
        guard let currencies = currencies, let quotes = quotes else {
            return
        }
        let currenciesCatalog = Dictionary(uniqueKeysWithValues: currencies.currencies.map{ ($0.code, $0) })
        let converter = Converter(currencies: currencies, quotes: quotes)
        guard let mxnCurrency = currenciesCatalog[mxn],
              let jpyCurrency = currenciesCatalog[jpy],
              let usdCurrency = currenciesCatalog[usd],
              let mxnConversion = converter.convert(source: mxnCurrency, value: 1) else {
            return
        }
        let usdValue = mxnConversion.results[usdCurrency]?.roundToDecimal(2)
        let jpyValue = mxnConversion.results[jpyCurrency]?.roundToDecimal(2)

        XCTAssertEqual(usdValue, mxnToUSDResult)
        XCTAssertEqual(jpyValue, mxnToJPYResult)
    }

    func testMultiplyConversion() {
        guard let currencies = currencies, let quotes = quotes else {
            return
        }
        let currenciesCatalog = Dictionary(uniqueKeysWithValues: currencies.currencies.map{ ($0.code, $0) })
        let converter = Converter(currencies: currencies, quotes: quotes)
        guard let mxnCurrency = currenciesCatalog[mxn],
              let jpyCurrency = currenciesCatalog[jpy],
              let usdCurrency = currenciesCatalog[usd],
              let mxnConversion = converter.convert(source: mxnCurrency, value: fiveTimesFactor) else {
            return
        }
        let usdValue = mxnConversion.results[usdCurrency]?.roundToDecimal(2)
        let jpyValue = mxnConversion.results[jpyCurrency]?.roundToDecimal(2)

        XCTAssertEqual(usdValue, mxnToUSDFiveTimesResult)
        XCTAssertEqual(jpyValue, mxnToJPYFiveTimesResult)
    }
}
