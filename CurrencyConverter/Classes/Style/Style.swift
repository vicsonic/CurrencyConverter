//
//  Style.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 06/01/21.
//

import UIKit

// MARK: - Style

protocol Style { }

struct NavigationBarStyle: Style {
    let tintColor = UIColor.white
    let barTintColor = UIColor.systemBlue
    let titleColor = UIColor.white
    let titleFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    let isTranslucent = false
}

protocol LabelStyle: Style {
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension LabelStyle {
    func toNSAttributedStringAttributes() -> [NSAttributedString.Key: Any] {
        return [
            .font: font,
            .foregroundColor: textColor
        ]
    }
}

struct TextFieldStyle: Style {
    let textColor = UIColor.label
    let font = UIFont.systemFont(ofSize: 20, weight: .bold)
    let borderColor = UIColor.systemGray5
}

struct AnyLabelStyle: LabelStyle {
    var textColor: UIColor
    var font: UIFont
}

struct FooterStyle: LabelStyle {
    let textColor = UIColor.systemGray5
    let font = UIFont.systemFont(ofSize: 12, weight: .light)
}

struct TableCellStyle: Style {
    let currencyStyle: LabelStyle = AnyLabelStyle(textColor: UIColor.label, font: UIFont.systemFont(ofSize: 17, weight: .regular))
    let tintColor = UIColor.systemPink
}

struct ConversionCellStyle: Style {
    let amountStyle: LabelStyle = AnyLabelStyle(textColor: UIColor.label, font: UIFont.systemFont(ofSize: 28, weight: .semibold))
    let symbolStyle: LabelStyle = AnyLabelStyle(textColor: UIColor.secondaryLabel, font: UIFont.systemFont(ofSize: 13, weight: .semibold))
    let nameStyle: LabelStyle = AnyLabelStyle(textColor: UIColor.systemGray, font: UIFont.systemFont(ofSize: 14, weight: .light))
    let borderColor = UIColor.systemGray5
}

// MARK: - Stylable

protocol Stylable {
    static func setStyle(_ style: Style)
    func setStyle(_ style: Style)
}

extension Stylable {
    func setStyle(_ style: Style) { }
}

extension UINavigationBar: Stylable {
    static func setStyle(_ style: Style) {
        guard let style = style as? NavigationBarStyle else {
            return
        }
        let attributes = [
            NSAttributedString.Key.foregroundColor: style.titleColor,
            NSAttributedString.Key.font: style.titleFont
        ]
        let appearance = self.appearance()
        appearance.tintColor = style.tintColor
        appearance.titleTextAttributes = attributes
        appearance.barTintColor = style.barTintColor
        appearance.isTranslucent = style.isTranslucent
    }
}

extension UILabel: Stylable {
    static func setStyle(_ style: Style) { }

    func setStyle(_ style: Style) {
        guard let style = style as? LabelStyle else {
            return
        }
        textColor = style.textColor
        font = style.font
    }
}

extension UITextField: Stylable {
    static func setStyle(_ style: Style) { }

    func setStyle(_ style: Style) {
        guard let style = style as? TextFieldStyle else {
            return
        }
        textColor = style.textColor
        font = style.font
        layer.borderColor = style.borderColor.cgColor
    }
}

extension UITableViewCell: Stylable {
    static func setStyle(_ style: Style) { }

    func setStyle(_ style: Style) {
        guard let style = style as? TableCellStyle else {
            return
        }
        tintColor = style.tintColor
        textLabel?.setStyle(style.currencyStyle)
    }
}

extension UITableViewHeaderFooterView: Stylable {
    static func setStyle(_ style: Style) { }

    func setStyle(_ style: Style) {
        guard let style = style as? LabelStyle else {
            return
        }
        textLabel?.setStyle(style)
    }
}

extension ConversionCell: Stylable {
    static func setStyle(_ style: Style) { }

    func setStyle(_ style: Style) {
        guard let style = style as? ConversionCellStyle else {
            return
        }
        layer.borderColor = style.borderColor.cgColor
        nameLabel.setStyle(style.nameStyle)
    }
}

struct AppStyle {
    static func setupStyle() {
        UINavigationBar.setStyle(NavigationBarStyle())
    }
}

