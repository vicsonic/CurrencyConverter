//
//  UITextFieldExtensions.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 06/01/21.
//

import UIKit

extension UITextField {

    enum Validation {
        case decimalNumber
    }

    private func validateDecimalNumber(in range: NSRange, originalString original: String?, replacementString replacement: String) -> Bool {
        let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: replacement))
        let withDecimal = (replacement == NumberFormatter().decimalSeparator && original?.contains(replacement) == false)
        return isNumber || withDecimal
    }

    func shouldChangeCharactersIn(range: NSRange, originalString original: String?, replacementString replacement: String, validation: Validation) -> Bool {
        switch validation {
        case .decimalNumber:
            return validateDecimalNumber(in: range, originalString: original, replacementString: replacement)
        }
    }
}
