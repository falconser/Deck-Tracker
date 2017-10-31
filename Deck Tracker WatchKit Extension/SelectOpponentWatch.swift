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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // Saves info for opponent class and returns to Main View
    @objc @IBAction func warriorButtonPressed() {
        UserDefaults.standard.set("Warrior", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func paladinButtonPressed() {
        UserDefaults.standard.set("Paladin", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func shamanButtonPressed() {
        UserDefaults.standard.set("Shaman", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func hunterButtonPressed() {
        UserDefaults.standard.set("Hunter", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func druidButtonPressed() {
        UserDefaults.standard.set("Druid", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func rogueButtonPressed() {
        UserDefaults.standard.set("Rogue", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func warlockButtonPressed() {
        UserDefaults.standard.set("Warlock", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func mageButtonPressed() {
        UserDefaults.standard.set("Mage", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
    
    @objc @IBAction func priestButtonPressed() {
        UserDefaults.standard.set("Priest", forKey: "Watch Opponent Class")
        UserDefaults.standard.synchronize()
        self.pop()
    }
}
