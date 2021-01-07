//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 06/01/21.
//

import UIKit

class CurrencyCell: UITableViewCell, Renderizer {

    typealias R = Currency

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Renderizer

    func update(using rendereable: Currency) {
        textLabel?.text = "\(rendereable.code) - \(rendereable.name)"
    }

    func updateAccessoryType(selected: Bool) {
        accessoryType = selected ? .checkmark : .none
    }
}
