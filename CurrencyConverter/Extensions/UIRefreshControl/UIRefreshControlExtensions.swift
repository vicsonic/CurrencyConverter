//
//  UIRefreshControlExtensions.swift
//  CurrencyConverter
//
//  Created by Victor Soto on 08/01/21.
//

import UIKit

extension UIRefreshControl {
    func beginRefreshing(in scroll: UIScrollView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: -frame.size.height)
        scroll.setContentOffset(offsetPoint, animated: true)
    }
}
