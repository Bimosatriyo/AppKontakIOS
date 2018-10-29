//
//  NewContactTableViewController.swift
//  iOS_Kontak
//
//  Created by macintosh on 29/10/18.
//  Copyright © 2018 Bimo Satriyo. All rights reserved.
//

import UIKit

class NewContactTableViewController: UITableViewController {
    
    var contacts: Contacts?
    var data: [String] = []
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBAction func saveContact(_ sender: Any) {
        if checkAllFieldFilled() {
            contacts?.addToContacts(Contact(data: data))
            contacts?.addToSectionedContacts(Contact(data: data))
            contacts?.createContactsPlistFile()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkAllFieldFilled() -> Bool {
        var allFilled = true
        data = []
        for case let cell as UITableViewCell in self.view.subviews{
            for case let textField as UITextField in cell.contentView.subviews {
                if textField.text == "" {
                    allFilled = false
                    textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)])
                }
                data.insert(textField.text ?? "N/A", at: 0)
            }
        }
        return allFilled
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

