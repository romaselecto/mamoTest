//
//  ContactsHeaderView.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 11.07.2021.
//

import UIKit

class ContactsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    private var title = ""
    
    class var reuseIdentifier: String? {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureHeader(with text: String) {
        title = text
        configureUI()
    }

    private func configureUI() {
        titleLabel.text = title
        
        separatorView.isHidden = title == "Your friends on Mamo"
    }
}
