//
//  DeckTrackerWatch.swift
//  Deck Tracker WatchKit Extension
//
//  Created by Andrei Joghiu on 29/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import WatchKit
import Foundation


class DeckTrackerWatch: WKInterfaceController {
    // This is the main screen of the watch.
    
    @IBOutlet var selectDeckButton: WKInterfaceButton!
    @IBOutlet var selectOpponentButton: WKInterfaceButton!
    @IBOutlet var coinSwitch: WKInterfaceSwitch!
    @IBOutlet var winSwitch: WKInterfaceSwitch!
    @IBOutlet var tagsButton: WKInterfaceButton!
    @IBOutlet var saveGameButton: WKInterfaceButton!
    
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let defaults = UserDefaults.standard
    
    var coin = false
    var win = true
    var selectedDeckName = ""
    var selectedDeckClass = ""
    var selectedTag = ""


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        // Populates the "Selected Deck", "Opponent Class" and "Tags" buttons
        print("Watch app started")
        setSelectedDeckButton()
        setOpponentClassButton()
        setTagButton()
    }

    @objc @IBAction func saveButtonPressed() {
        
        // Gathers the data to make the dict to send the info to the phone
        var dict = [String:Any]()
        // Gets selected deck and selected class associated with the deck
        if let deckName = groupDefaults?.string(forKey:"Selected Deck Name"),
            let deckClass = groupDefaults?.string(forKey:"Selected Deck Class")
        {
            selectedDeckName = deckName
            selectedDeckClass = deckClass
            dict["selectedDeckName"] = selectedDeckName
            dict["selectedDeckClass"] = selectedDeckClass
        }
        
        dict["coin"] = coin
        dict["win"] = win

        // Gets the selected tag
        selectedTag = defaults.string(forKey:"Selected Tag Watch") ?? ""
        dict["watchSelectedTag"] = selectedTag
        
        // Saves the dictionary and sends the info to the phone
        // Gets the Opponent Class
        if let opponentClass = defaults.string(forKey:"Watch Opponent Class") {
            dict["watchOpponentClass"] = opponentClass
            if let _ = groupDefaults?.string(forKey:"Selected Deck Name") {
                groupDefaults?.set(dict, forKey: "Add Game Watch")
                groupDefaults?.synchronize()
                WCSession.default.transferUserInfo(["Save New Game" : ""])
            } else {
                saveGameButton.setTitle("Select a deck!")
            }
        }
        else {
            saveGameButton.setTitle("Opponent Class needed!")
        }
        
        // Remove saved settings
        defaults.removeObject(forKey: "Watch Opponent Class")
        defaults.removeObject(forKey: "Selected Tag Watch")
        setOpponentClassButtonBackgroundToBlack()
        willActivate()
    }
    
    func setSelectedDeckButton() {
        // Populates the selected deck button
        
        if let _ = groupDefaults?.integer(forKey:"Selected Deck ID"),
            let selectedDeckName = groupDefaults?.string(forKey:"Selected Deck Name"),
            let selectedDeckClass = groupDefaults?.string(forKey:"Selected Deck Class")
        {
                selectDeckButton.setTitle(selectedDeckName)
                colorCell(classToBeColored: selectedDeckClass, button: selectDeckButton, opponent: false, deckName: selectedDeckName)
        }
    }
    
    
    func setOpponentClassButton() {
        // Populates the opponent class button
        if let opponentClass = defaults.string(forKey:"Watch Opponent Class") {
            colorCell(classToBeColored: opponentClass, button: selectOpponentButton, opponent: true, deckName: "")
            saveGameButton.setTitle("Save Game")
        } else {
            selectOpponentButton.setTitle("Select Opponent")
            saveGameButton.setTitle("Opponent Class Needed!")
        }
    }
    
    
    func setOpponentClassButtonBackgroundToBlack() {
        // Sets the opponent class button to black
        selectOpponentButton.setBackgroundColor(UIColor(rgbValue:0x333333))
    }
    
    
    func colorCell (classToBeColored:String, button:WKInterfaceButton, opponent:Bool, deckName:String) {
        // Colors the cell according to the Class specified
        if classToBeColored == "Warrior" {
            button.setBackgroundColor(UIColor(rgbValue:0xCC0000))
        } else if classToBeColored == "Paladin" {
            button.setBackgroundColor(UIColor(rgbValue:0xCCC333))
        } else if classToBeColored == "Shaman" {
            button.setBackgroundColor(UIColor(rgbValue:0x3366CC))
        } else if classToBeColored == "Hunter" {
            button.setBackgroundColor(UIColor(rgbValue:0x339933))
        } else if classToBeColored == "Druid" {
            button.setBackgroundColor(UIColor(rgbValue:0x990000))
        } else if classToBeColored == "Rogue" {
            button.setBackgroundColor(UIColor(rgbValue:0x666666))
        } else if classToBeColored == "Warlock" {
            button.setBackgroundColor(UIColor(rgbValue:0x9900CC))
        } else if classToBeColored == "Mage" {
            button.setBackgroundColor(UIColor(rgbValue:0x009999))
        } else if classToBeColored == "Priest" {
            button.setBackgroundColor(UIColor(rgbValue:0x999999))
        }

        let text = opponent ? "Versus: \(classToBeColored)" : "Deck: \(deckName)"
        let attributedTitle = NSAttributedString(string: text,
                                                 attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 15.0)!,
                                                              NSAttributedStringKey.foregroundColor: UIColor.green])
        button.setAttributedTitle(attributedTitle)
    }
    
    
    
    @objc @IBAction func coinSwitchToggled(value: Bool) {
        // Keep track of coin switch
        coin = value
    }
    
    
    @objc @IBAction func winSwitchToggled(value: Bool) {
        // Keep track of win switch
        win = value
    }
    
    func setTagButton() {
        // Populates the tags button
        if let defaultsTag = UserDefaults.standard.string(forKey:"Selected Tag Watch") {
            selectedTag = defaultsTag
            tagsButton.setTitle("Tag: " + selectedTag)
        } else {
            tagsButton.setTitle("Add Tag")
        }
    }

}
