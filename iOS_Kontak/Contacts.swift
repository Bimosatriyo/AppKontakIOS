//
//  Contacts.swift
//  iOS_Kontak
//
//  Created by macintosh on 29/10/18.
//  Copyright © 2018 Bimo Satriyo. All rights reserved.
//

import Foundation
import UIKit

struct Contact: Codable, CustomStringConvertible, Comparable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var isfavorite: Bool
    var imageurl: String
    
    init(data: [String]) {
        self.id = NSIntegerMax
        self.firstName = data[0]
        self.lastName = data[1]
        self.isfavorite = false
        self.imageurl = data[3]
    }
    
    var boldLastName: NSAttributedString {
        let attributedFullName = NSMutableAttributedString(string: self.fullName)
        attributedFullName.addAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)], range: NSMakeRange(firstName.count + 1, lastName.count))
        return attributedFullName
    }
    
    var fullName:String {
        return "\(firstName) \(lastName)"
    }
    
    var detail:String {
        return "\(firstName) \(lastName)\nFavorite: \(isfavorite)\nImage: \(imageurl)\n"
    }
    
    var formattedJSON: String {
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let json = try? encoder.encode(self) else {
            print("Can't create JSON for contact")
            return ""
        }
        
        return String(data: json, encoding: .utf8) ?? ""
    }
    
    var description: String {
        return "\(firstName) \(lastName)"
    }
    
    var key: String {
        var contactKey = lastName.capitalized.prefix(1).description
        do {
            let regex = try NSRegularExpression(pattern: "[a-zA-Z]")
            let result = regex.matches(in: contactKey, range: NSMakeRange(0, 1))
            if result.count == 0 {
                contactKey = "#"
            }
        } catch {
            print("Regex error")
        }
        return contactKey
    }
    
    static func <(lhs: Contact, rhs: Contact) -> Bool {
        if (lhs.key != "#" && rhs.key != "#") || (lhs.key == "#" && rhs.key == "#") {
            if lhs.lastName != rhs.lastName {
                return lhs.lastName < rhs.lastName
            } else if lhs.firstName != rhs.firstName {
                return lhs.firstName < rhs.firstName
            }
        } else if lhs.key == "#" && rhs.key != "#" {
            return false
        } else if lhs.key != "#" && rhs.key == "#" {
            return true
        } else {
            print("Error in < compare")
        }
        return true
    }
    
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        return (lhs.firstName == rhs.firstName) && (lhs.lastName == rhs.lastName)
    }
}

class Contacts {
    var contacts: [Contact]
    var sectionKeys: [String] = []
    var sectionedContacts: Dictionary<String, Array<Contact>> = [:]
    
    init() {
        contacts = []
        loadContacts()
    }
    
    var count: Int {
        return contacts.count
    }
    
    func contact(at indexPath: IndexPath) -> Contact {
        if indexPath.row >= contacts.count {
            return contacts[0]
        }
        return contacts[indexPath.row]
    }
    
    func loadContacts() {
        if isFirstLaunch() {
            print("Loading bundled JSON.")
            contacts = loadBundledJSON()
            createContactsPlistFile()
        } else {
            print("Loading contacts from app directory.")
            contacts = loadSavedContacts()
        }
        contacts.sort()
        self.loadSortedContacts()
        
    }
    
    func loadSortedContacts() {
        for contact in contacts {
            if var contactSection = sectionedContacts[contact.key] {
                contactSection.append(contact)
                sectionedContacts.updateValue(contactSection, forKey: contact.key)
            } else {
                sectionedContacts.updateValue([contact], forKey: contact.key)
                sectionKeys.append(contact.key)
            }
        }
        keySort()
    }
    
    func keySort() {
        sectionKeys.sort(by: {
            if $0 == "#" {
                return false
            } else if $1 == "#" {
                return true
            } else {
                return $0 < $1
            }
        })
    }
    
    func addToContacts(_ contact: Contact) {
        contacts.append(contact)
        contacts.sort()
    }
    
    func addToSectionedContacts(_ contact: Contact) {
        if var contactSection = sectionedContacts[contact.key] {
            contactSection.append(contact)
            contactSection.sort( by: {
                if ($0.lastName != $1.lastName) {
                    return $0.lastName < $1.lastName
                } else {
                    return $0.firstName < $1.firstName
                }
            })
            sectionedContacts.updateValue(contactSection, forKey: contact.key)
        } else {
            sectionedContacts.updateValue([contact], forKey: contact.key)
            sectionKeys.append(contact.key)
        }
        keySort()
    }
    
    func loadBundledJSON() -> [Contact] {
        let url = Bundle.main.url(forResource: "contacts", withExtension: "json")
        
        guard let jsonData = try? Data(contentsOf: url!) else {
            return []
        }
        
        let jsonDecoder = JSONDecoder()
        
        let contactsArray = try? jsonDecoder.decode([Contact].self, from: jsonData)
        
        return contactsArray ?? []
    }
    
    func loadSavedContacts() -> [Contact] {
        guard let contactsURL = applicationDirectory().appendingPathComponent("contacts.plist") else {
            print("Can't create URl to app dir.")
            return []
        }
        
        print(contactsURL)
        
        guard let contactsData = try? Data.init(contentsOf: contactsURL) else {
            print("Couldn't load data from app dir.")
            return []
        }
        
        let contactsDecoder = PropertyListDecoder()
        let contactsArray = try? contactsDecoder.decode([Contact].self, from: contactsData)
        
        return contactsArray ?? []
    }
    
    func createContactsPlistFile() {
        guard let contactsPlistFileURL = applicationDirectory().appendingPathComponent("contacts.plist") else {
            print("Could not get the URL for the data save.")
            return
        }
        
        let plistEncoder = PropertyListEncoder()
        let contactsData = try? plistEncoder.encode(contacts.self)
        
        do {
            try contactsData?.write(to: contactsPlistFileURL)
        } catch {
            print(error)
        }
    }
}

