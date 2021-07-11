//
//  FrequeentContactCVCell.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import UIKit

class FrequeentContactCVCell: BaseCollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageLabel: UILabel!
    @IBOutlet weak var mamoLogoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - Private variables
    private var contactModel: FetchedContactML?
    private var item: Int = 0
    
    // MARK: - Private Variables
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Public Functions
    func configureCell(_ model: FetchedContactML, aItem: Int) {
        contactModel = model
        updateUI()
    }
    
    private func updateUI() {
        guard let model = contactModel else {
            return
        }
        backView.borderWidth = model.isSelected ?? false ? 2 : 0
        backView.borderColor = UIColor(red: 0.2, green: 0.2, blue: 1, alpha: 1)
        guard let mamoModel = model.mamoModel else {
            mamoLogoImageView.isHidden = true
            
            let username = "\(model.firstName) \(model.lastName)"
            usernameLabel.text = username
            
            if let imageData = model.image {
                userImageView.image = UIImage(data: imageData)
                userImageLabel.text = ""
            } else {
                let randomColor = AppSettings.randomColors[item]
                colorView.backgroundColor = randomColor.withAlphaComponent(0.3)
                userImageLabel.textColor = randomColor
                userImageView.image = nil
                userImageLabel.text = username.prefix(1).uppercased()
            }
            return
        }
        
        mamoLogoImageView.isHidden = false
        let username = mamoModel.publicName != nil ? "\(mamoModel.publicName ?? "")" : "\(model.firstName) \(model.lastName)"
        usernameLabel.text = username
        
        if let imageData = model.image {
            userImageView.image = UIImage(data: imageData)
            userImageLabel.text = ""
        } else {
            let randomColor = AppSettings.randomColors[item]
            colorView.backgroundColor = randomColor.withAlphaComponent(0.1)
            userImageLabel.textColor = randomColor
            userImageView.image = nil
            userImageLabel.text = username.prefix(1).uppercased()
        }
    }
}
