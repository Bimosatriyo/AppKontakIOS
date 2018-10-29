//
//  Utilities.swift
//  iOS_Kontak
//
//  Created by macintosh on 29/10/18.
//  Copyright © 2018 Bimo Satriyo. All rights reserved.
//

import Foundation

func isFirstLaunch() -> Bool {
    let defaults = UserDefaults.standard
    
    if defaults.bool(forKey: "isFirstLaunch") == true {
        print("First Launch!")
        defaults.set(false, forKey: "isFirstLaunch")
        return true
    } else {
        print("Not first launch")
        return false
    }
}

func applicationDirectory() -> NSURL {
    let fileManager = FileManager.default
    
    let urls = fileManager.urls(
        for: FileManager.SearchPathDirectory.documentDirectory,
        in: FileManager.SearchPathDomainMask.userDomainMask) as [NSURL]
    
    let documentsURL = urls[0]
    
    return documentsURL
}
