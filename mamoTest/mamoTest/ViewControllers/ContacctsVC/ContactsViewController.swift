//
//  ContactsViewController.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 09.07.2021.
//

import UIKit
import ContactsUI
import Alamofire

protocol ContactsDelegate: class {
    func pressedOnContact(model: FetchedContactML)
}

class ContactsViewController: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var noAccessView: UIView!
    
    private var contactsViewModel : ContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contactsViewModel =  ContactsViewModel()
        
        self.contactsViewModel.bindContactsViewModelToController = { succes in
            if succes {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3) {
                        self.noAccessView.alpha = 0
                    }
                }
                self.tableView.reloadData()
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3) {
                        self.noAccessView.alpha = 1
                    }
                }
            }
        }
        
        registerCell()
        updateUI()
    }

    // MARK: - Private Methods
    private func updateUI() {
        nextButton.backgroundColor = contactsViewModel.selectedContact != nil ? UIColor(red: 0.2, green: 0.2, blue: 1, alpha: 1) : UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
        nextButton.setTitleColor(contactsViewModel.selectedContact != nil ? .white : UIColor(red: 0.78, green: 0.82, blue: 0.86, alpha: 1), for: .normal)
    }
    
    private func registerCell() {
        FrequentsTVCell.registerForTableView(aTableView: tableView)
        ContactTVCell.registerForTableView(aTableView: tableView)
        tableView.register(UINib(nibName: "ContactsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: ContactsHeaderView.reuseIdentifier!)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - IBActions
    @IBAction func onNextButtonPressed(_ sender: Any) {
        guard let contact = contactsViewModel.selectedContact else {
            return
        }
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
            vc.configureVC(contact)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onRqueestAccessButtonPresseed(_ sender: Any) {
        DispatchQueue.main.async {
            let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: - TableView

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return (contactsViewModel.myContactsToShow.count > 0 ? 1 : 0) + (contactsViewModel.frequentsMamoContactsToShow.count > 0 ? 1 : 0) + (contactsViewModel.mamoContactsToShow.count > 0 ? 1 : 0)
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 {
                return 1
            } else if contactsViewModel.mamoContactsToShow.count > 0 {
                return contactsViewModel.mamoContactsToShow.count
            }
        } else if section == 1 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 && contactsViewModel.mamoContactsToShow.count > 0 {
                return contactsViewModel.mamoContactsToShow.count
            }
        }
        return contactsViewModel.myContactsToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FrequentsTVCell.cellIdentifier, for: indexPath) as? FrequentsTVCell else { return UITableViewCell() }
                cell.configureCell(contactsViewModel.frequentsMamoContactsToShow, aDelegate: self)
                return cell
            } else if contactsViewModel.mamoContactsToShow.count > 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTVCell.cellIdentifier, for: indexPath) as? ContactTVCell else { return UITableViewCell() }
                cell.configureCell(contactsViewModel.mamoContactsToShow[indexPath.item], aItem: indexPath.row)
                return cell
            }
        } else if indexPath.section == 1 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 && contactsViewModel.mamoContactsToShow.count > 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTVCell.cellIdentifier, for: indexPath) as? ContactTVCell else { return UITableViewCell() }
                cell.configureCell(contactsViewModel.mamoContactsToShow[indexPath.item], aItem: indexPath.row)
                return cell
            }
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTVCell.cellIdentifier, for: indexPath) as? ContactTVCell else { return UITableViewCell() }
        cell.configureCell(contactsViewModel.myContactsToShow[indexPath.item], aItem: indexPath.row)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 {
                return 120
            }
        }
        return 58
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if contactsViewModel.frequentsMamoContactsToShow.count == 0 && contactsViewModel.mamoContactsToShow.count > 0 {
                contactsViewModel.selectedContact = contactsViewModel.mamoContactsToShow[indexPath.item]
                updateUI()
                return
            }
        } else if indexPath.section == 1 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 && contactsViewModel.mamoContactsToShow.count > 0 {
                contactsViewModel.selectedContact = contactsViewModel.mamoContactsToShow[indexPath.item]
                updateUI()
                return
            }
        }
        contactsViewModel.selectedContact = contactsViewModel.myContactsToShow[indexPath.item]
        updateUI()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContactsHeaderView.reuseIdentifier!) as? ContactsHeaderView else { return nil }
        if section == 0 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 {
                headerView.configureHeader(with: "Frequents")
                return headerView
            } else if contactsViewModel.mamoContactsToShow.count > 0 {
                headerView.configureHeader(with: "Your friends on Mamo")
                return headerView
            }
        } else if section == 1 {
            if contactsViewModel.frequentsMamoContactsToShow.count > 0 && contactsViewModel.mamoContactsToShow.count > 0 {
                headerView.configureHeader(with: "Your friends on Mamo")
                return headerView
            }
        }
        headerView.configureHeader(with: "Your contacts")
        return headerView
    }

    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 44
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 0.001
    }
    
}

extension ContactsViewController: ContactsDelegate {
    func pressedOnContact(model: FetchedContactML) {
        contactsViewModel.selectedContact = model
        updateUI()
    }
}
