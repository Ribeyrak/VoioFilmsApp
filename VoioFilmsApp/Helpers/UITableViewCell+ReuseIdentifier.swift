//
//  UITableViewCell+ReuseIdentifier.swift
//  VoioFilmsApp
//
//  Created by Evhen Lukhtan on 30.04.2023.
//

import UIKit

protocol IdealReuseIdentifier {
    static var idealReuseIdentifier: String { get }
}

extension IdealReuseIdentifier {
    static var idealReuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewCell: IdealReuseIdentifier {}
extension UICollectionViewCell: IdealReuseIdentifier {}
extension UITableViewHeaderFooterView: IdealReuseIdentifier {}

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(withClass cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withIdentifier: cellClass.idealReuseIdentifier, for: indexPath) as! Cell
    }

    func dequeueReusableHeaderFooterView<ReusableView: UITableViewHeaderFooterView>(
        withClass viewClass: ReusableView.Type) -> ReusableView {
            dequeueReusableHeaderFooterView(withIdentifier: viewClass.idealReuseIdentifier) as! ReusableView
        }
}

extension UICollectionView {
    func dequeueReusableCell<Cell: UICollectionViewCell>(withClass cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        dequeueReusableCell(withReuseIdentifier: cellClass.idealReuseIdentifier, for: indexPath) as! Cell
    }
}

