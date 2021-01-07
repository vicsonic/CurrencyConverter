//
//  DateExtensions.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 05/01/21.
//

import Foundation

extension Date {
    func minutesBetween(date: Date) -> Int {
        Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }
}

