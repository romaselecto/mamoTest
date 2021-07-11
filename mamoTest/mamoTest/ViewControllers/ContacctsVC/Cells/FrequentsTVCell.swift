//
//  FrequentsTVCell.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import UIKit

class FrequentsTVCell: BaseTableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Private variables
    private var contacts: [FetchedContactML] = []
    private weak var delegate: ContactsDelegate?
    
    override class var cellIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
    }

    private func registerCell() {
        let nib = UINib(nibName: FrequeentContactCVCell.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: FrequeentContactCVCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 0, left: 17, bottom: 0, right: 17)
    }
    
    func configureCell(_ aContacts: [FetchedContactML], aDelegate: ContactsDelegate?) {
        delegate = aDelegate
        contacts = aContacts
//        helper = aHelper
        collectionView.reloadData()
    }
}

extension FrequentsTVCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrequeentContactCVCell.cellIdentifier, for: indexPath) as? FrequeentContactCVCell else { return UICollectionViewCell() }
        cell.configureCell(contacts[indexPath.item], aItem: indexPath.item)
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 77, height: 107)
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pressedOnContact(model: contacts[indexPath.item])
    }
}
