//
//  ConversionCell.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 06/01/21.
//

import UIKit

class ConversionCell: UICollectionViewCell, Renderizer {

    typealias R = ConversionResult

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.cornerRadius = 8
    }

    // MARK: - Renderizer

    func update(using rendereable: ConversionResult) {
//        symbolLabel.text = rendereable.currency.symbols.first ?? rendereable.currency.code
        valueLabel.text = rendereable.amount()
        nameLabel.text = rendereable.currency.name
    }
}
