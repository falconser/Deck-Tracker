//
//  SelectOpponentWatch.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 2/6/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import WatchKit
import Foundation


class SelectOpponentWatch: WKInterfaceController {
    
    @IBOutlet var warriorButton: WKInterfaceButton!
    @IBOutlet var paladinButton: WKInterfaceButton!
    @IBOutlet var shamanButton: WKInterfaceButton!
    @IBOutlet var hunterButton: WKInterfaceButton!
    @IBOutlet var druidButton: WKInterfaceButton!
    @IBOutlet var rogueButton: WKInterfaceButton!
    @IBOutlet var warlockButton: WKInterfaceButton!
    @IBOutlet var mageButton: WKInterfaceButton!
    @IBOutlet var priestButton: WKInterfaceButton!
    
    private func setClass(_ classString: String) {
        UserDefaults.standard.set(classString, forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
    }
    
    // Saves info for opponent class and returns to Main View
    @objc @IBAction func warriorButtonPressed() {
        setClass("Warrior")
        self.pop()
    }
    
    @objc @IBAction func paladinButtonPressed() {
        setClass("Paladin")
        self.pop()
    }
    
    @objc @IBAction func shamanButtonPressed() {
        setClass("Shaman")
        self.pop()
    }
    
    @objc @IBAction func hunterButtonPressed() {
        setClass("Hunter")
        self.pop()
    }
    
    @objc @IBAction func druidButtonPressed() {
        setClass("Druid")
        self.pop()
    }
    
    @objc @IBAction func rogueButtonPressed() {
        setClass("Rogue")
        self.pop()
    }
    
    @objc @IBAction func warlockButtonPressed() {
        setClass("Warlock")
        self.pop()
    }
    
    @objc @IBAction func mageButtonPressed() {
        setClass("Mage")
        self.pop()
    }
    
    @objc @IBAction func priestButtonPressed() {
        setClass("Priest")
        self.pop()
    }
}
