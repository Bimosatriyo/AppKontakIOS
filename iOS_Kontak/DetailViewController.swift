//
//  DetailViewController.swift
//  iOS_Kontak
//
//  Created by macintosh on 29/10/18.
//  Copyright © 2018 Bimo Satriyo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var contact: Contact?
    var toolbarButtonText = ""
    var viewingInfo: Bool = true
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var toolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var navbarTitle: UINavigationItem!
    
    @IBOutlet weak var messageButtonTap: UIButton!
    
    @IBOutlet weak var callButtonTap: UIButton!
    
    @IBOutlet weak var emailButtonTap: UIButton!
    
    @IBOutlet weak var favouriteButtonTap: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

