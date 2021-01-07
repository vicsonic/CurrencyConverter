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
        let style = ConversionCellStyle()
        let symbol = rendereable.currency.symbols.first ?? rendereable.currency.code
        let amountAttributedString = NSMutableAttributedString(string: rendereable.amount(), attributes: style.amountStyle.toNSAttributedStringAttributes())
        let symbolAttributedString = NSAttributedString(string: symbol, attributes: style.symbolStyle.toNSAttributedStringAttributes())
        amountAttributedString.append(symbolAttributedString)
        valueLabel.attributedText = amountAttributedString
        nameLabel.text = rendereable.currency.name
    }
}
