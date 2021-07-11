//
//  BaseTableViewCell.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import Foundation
import UIKit

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Class Methods

    class var className: String {
        return String(describing: self)
    }

    class var cellIdentifier: String {
        assertionFailure("Method 'cellIdentifier' need to be overriden in BaseTableViewCell subclass")
        return ""
    }

    class func nibName() -> String {
        return String(describing: className).components(separatedBy: ".").last!
    }

    class func registerForTableView(aTableView: UITableView) {
        let nib = UINib(nibName: className, bundle: nil)
        aTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}
