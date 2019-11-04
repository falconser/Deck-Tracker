//
//  About.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 27/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class About: UIViewController {

    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        versionLabel.text = "Version: \(version)"
    }

    @objc @IBAction func emailButtonPressed(_ sender:UIButton) {
        let email = "falcon@awsmapps.com"
        let url = URL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url!)
    }
}
