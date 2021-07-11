//
//  ContactsViewModel.swift
//  mamoTest
//
//  Created by Roma Osiychuk on 11.07.2021.
//

import Foundation
import ContactsUI
import Alamofire

class ContactsViewModel : NSObject {
    
    private var fetchedContacts = [FetchedContactML]()
    private var mamoContacts = [UserML]()
    private var frequentsContacts = [UserML]()
    
    private(set) var myContactsToShow = [FetchedContactML]()
    private(set) var mamoContactsToShow = [FetchedContactML]()
    private(set) var frequentsMamoContactsToShow = [FetchedContactML]()
    
    var selectedContact: FetchedContactML? {
        didSet {
            self.updateData()
        }
    }
    
    var bindContactsViewModelToController : ((Bool) -> ()) = {_ in }
    
    override init() {
        super.init()
        fetchContacts()
    }
    
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                self.bindContactsViewModelToController(false)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactImageDataKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in

                        let phones = contact.phoneNumbers.compactMap {$0.value.stringValue}
                        let emails = contact.emailAddresses.compactMap {$0.value as String}
                        self.fetchedContacts.append(FetchedContactML(firstName: contact.givenName, lastName: contact.familyName, phoneNumbers: phones, emailAddresses: emails, image: contact.imageData))
                    })
                    self.startFetching()
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                self.bindContactsViewModelToController(false)
                print("access denied")
            }
        }
    }
    
    private func startFetching() {
        (Utils.topViewController() as? BaseVC)?.startIndicator()
        let group = DispatchGroup()
        
        group.enter()
        getFrequentReceivers {
            group.leave()
        }
        
        group.enter()
        searchAccounts {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            (Utils.topViewController() as? BaseVC)?.stopIndicator()
            strongSelf.updateData()
        }
    }
    
    private func updateData() {
        myContactsToShow = []
        mamoContactsToShow = []
        frequentsMamoContactsToShow = []
        
        for eachContact in fetchedContacts {
            var isMamoContact = false
            for eachMamo in mamoContacts {
                if eachMamo.key == "email", let value = eachMamo.value {
                    if eachContact.emailAddresses.contains(value) {
                        isMamoContact = true
                        addMamoContact(eachContact, mamoContact:eachMamo)
                    }
                } else if eachMamo.key == "phone", let value = eachMamo.value {
                    if eachContact.phoneNumbers.contains(value) {
                        isMamoContact = true
                        addMamoContact(eachContact, mamoContact:eachMamo)
                    }
                }
            }
            if !isMamoContact {
                var newContact = eachContact
                if newContact.firstName == selectedContact?.firstName && newContact.lastName == selectedContact?.lastName {
                    newContact.isSelected = true
                }
                myContactsToShow.append(newContact)
            }
        }
        self.bindContactsViewModelToController(true)
    }
    
    private func addMamoContact(_ myContact: FetchedContactML, mamoContact: UserML) {
        var newContact = myContact
        newContact.mamoModel = mamoContact
        if newContact.firstName == selectedContact?.firstName && newContact.lastName == selectedContact?.lastName {
            newContact.isSelected = true
        }
        if frequentsContacts.contains(where: {$0.id == mamoContact.id}) {
            newContact.isFrequent = true
            frequentsMamoContactsToShow.append(newContact)
        }
        
        mamoContactsToShow.append(newContact)
        
        
    }
    func getParametersForSrarch() -> Parameters {
        var emails: [String] = []
        var phones: [String] = []
        for eachContact in fetchedContacts {
            emails.append(contentsOf: eachContact.emailAddresses)
            phones.append(contentsOf: eachContact.phoneNumbers)
        }
        
        return ["emails":emails, "phones":phones]
    }
    // MARK: - API functions
    
    func getFrequentReceivers(aCompletion: @escaping void_block) {
        APIManager.shared().frequents { [weak self] (result: APIManager.Result<[UserML]>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let users):
                strongSelf.frequentsContacts = users
            case .failure(let errorMsg):
                print(errorMsg)
            }
            aCompletion()
        }
    }
    
    func searchAccounts(aCompletion: @escaping void_block) {
        let params = getParametersForSrarch()
        APIManager.shared().accounts(params) {  [weak self] (result: APIManager.Result<[UserML]>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let users):
                strongSelf.mamoContacts = users
            case .failure(let errorMsg):
                print(errorMsg)
            }
            aCompletion()
        }
    }
}
