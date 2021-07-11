//
//  DetailsVC.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 11.07.2021.
//

import UIKit

class DetailsVC: BaseVC {

    // MARK: - Outlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageLabel: UILabel!
    @IBOutlet weak var mamoLogoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    
    // MARK: - Private variables
    private var contactModel: FetchedContactML?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    // MARK: - Public Functions
    func configureVC(_ model: FetchedContactML) {
        contactModel = model
    }
    
    private func updateUI() {
        guard let model = contactModel else {
            return
        }
        
        guard let mamoModel = model.mamoModel else {
            mamoLogoImageView.isHidden = true
            
            let username = "\(model.firstName) \(model.lastName)"
            usernameLabel.text = username
            
            if let imageData = model.image {
                userImageView.image = UIImage(data: imageData)
                userImageLabel.text = ""
            } else {
                let randomColor = UIColor(red: .random(in: 0...1),
                                          green: .random(in: 0...1),
                                          blue: .random(in: 0...1),
                                          alpha: 1.0)
                colorView.backgroundColor = randomColor.withAlphaComponent(0.3)
                userImageLabel.textColor = randomColor
                userImageView.image = nil
                userImageLabel.text = username.prefix(1).uppercased()
            }
            
            contactInfoLabel.text = """
                                    Contact: \(username)
                                    Id:
                                    phone number or email: \(model.emailAddresses.joined(separator: ",")) \(model.phoneNumbers.joined(separator: ","))
                                    Frequent: \(model.isFrequent ?? false)
                                    Mamo: false
                                    """
            
            return
        }
        
        mamoLogoImageView.isHidden = false
        let username = mamoModel.publicName != nil ? "\(mamoModel.publicName ?? "")" : "\(model.firstName) \(model.lastName)"
        usernameLabel.text = username
        
        if let imageData = model.image {
            userImageView.image = UIImage(data: imageData)
            userImageLabel.text = ""
        } else {
            let randomColor = UIColor(red: .random(in: 0...1),
                                      green: .random(in: 0...1),
                                      blue: .random(in: 0...1),
                                      alpha: 1.0)
            colorView.backgroundColor = randomColor.withAlphaComponent(0.1)
            userImageLabel.textColor = randomColor
            userImageView.image = nil
            userImageLabel.text = username.prefix(1).uppercased()
        }
        
        contactInfoLabel.text = """
                                Contact: \(username)
                                Id: \(mamoModel.id)
                                phone number or email: \(model.emailAddresses.joined(separator: ",")) \(model.phoneNumbers.joined(separator: ","))
                                Frequent: \(model.isFrequent ?? false)
                                Mamo: true
                                """
    }

}
