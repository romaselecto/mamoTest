//
//  BaseCollectionViewCell.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    // MARK: - Internal Variables

    @IBOutlet var SELContentView: UIView!

    var className: String {
        return String(describing: type(of: self))
    }

    // MARK: - Class Methods

    class var className: String {
        return String(describing: self)
    }

    class var cellIdentifier: String {
        assertionFailure("Method 'cellIdentifier' need to be overriden in BaseCollectionViewCell subclass")
        return ""
    }

    class func nibName() -> String {
        return String(describing: className).components(separatedBy: ".").last!
    }

    class func registerForCollectionView(aCollectionView: UICollectionView) {
        let nib = UINib(nibName: className, bundle: nil)
        aCollectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
}
