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
    
    var coinSwitchInt:Int = 0
    var winSwitchInt:Int = 1
    var selectedDeckName: String = ""
    var selectedDeckClass: String = ""
    var selectedTag:String = ""


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

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    @objc @IBAction func saveButtonPressed() {
        
        // Gathers the data to make the dict to send the info to the phone
        let dict = NSMutableDictionary()
        // Gets selected deck and selected class associated with the deck
        if let deckName = groupDefaults?.string(forKey:"Selected Deck Name"),
            let deckClass = groupDefaults?.string(forKey:"Selected Deck Class")
        {
            selectedDeckName = deckName
            selectedDeckClass = deckClass
            dict.setValue(selectedDeckName, forKey: "selectedDeckName")
            dict.setValue(selectedDeckClass, forKey: "selectedDeckClass")
        }
        
        // Gets the Opponent Class
        let opponentClass = defaults.string(forKey:"Watch Opponent Class")
        dict.setValue(opponentClass, forKey: "watchOpponentClass")
        
        // Gets if user had coin or not
        var coin:Bool = false
        if coinSwitchInt == 0 {
            coin = false
        } else {
            coin = true
        }
        dict.setValue(coin, forKey: "coin")
        
        // Gets if user won or not
        var win:Bool = true
        if winSwitchInt == 0 {
            win = false
        } else {
            win = true
        }
        dict.setValue(win, forKey: "win")
        
        // Gets the selected tag
        selectedTag = defaults.string(forKey:"Selected Tag Watch") ?? ""
        
        dict.setValue(selectedTag, forKey: "watchSelectedTag")
        
        // Saves the dictionary and sends the info to the phone
        if opponentClass != nil {
                WKInterfaceController.openParentApplication(["Save New Game" : ""] , reply: { [](reply, error) -> Void in
                    })
            if let _ = groupDefaults?.string(forKey:"Selected Deck Name") {
                groupDefaults?.set(dict, forKey: "Add Game Watch")
                groupDefaults?.synchronize()
            } else {
                saveGameButton.setTitle("Select a deck!")
            }

            
        } else {
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
            //selectOpponentButton.setTitle("Opponent: " + String(opponentClass))
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
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
               let attibuteString = NSAttributedString(string: "Versus: Warrior", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Paladin" {
            button.setBackgroundColor(UIColor(rgbValue:0xCCC333))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Paladin", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Shaman" {
            button.setBackgroundColor(UIColor(rgbValue:0x3366CC))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Shaman", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Hunter" {
            button.setBackgroundColor(UIColor(rgbValue:0x339933))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Hunter", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Druid" {
            button.setBackgroundColor(UIColor(rgbValue:0x990000))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Druid", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Rogue" {
            button.setBackgroundColor(UIColor(rgbValue:0x666666))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Rogue", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Warlock" {
            button.setBackgroundColor(UIColor(rgbValue:0x9900CC))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Warlock", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Mage" {
            button.setBackgroundColor(UIColor(rgbValue:0x009999))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Mage", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        } else if classToBeColored == "Priest" {
            button.setBackgroundColor(UIColor(rgbValue:0x999999))
            let boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
            let greenColor = UIColor.green
            let attributeDictionary = [NSAttributedStringKey.font: boldFont, NSAttributedStringKey.foregroundColor: greenColor]
            if opponent == true {
                let attibuteString = NSAttributedString(string: "Versus: Priest", attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            } else {
                let attibuteString = NSAttributedString(string: "Deck: " + deckName, attributes: attributeDictionary)
                button.setAttributedTitle(attibuteString)
            }
        }
    }
    
    
    
    @objc @IBAction func coinSwitchToggled(value: Bool) {
        // Keep track of coin switch
        if value {
            coinSwitchInt = 1
        } else {
            coinSwitchInt = 0
        }
    }
    
    
    @objc @IBAction func winSwitchToggled(value: Bool) {
        // Keep track of win switch
        if value {
            winSwitchInt = 1
        } else {
            winSwitchInt = 0
        }
    }
    
    func setTagButton() {
        // Populates the tags button
        if let defaultsTag = UserDefaults.standard.string(forKey:"Selected Tag Watch") {
            selectedTag = defaultsTag
            tagsButton.setTitle("Tag: " + selectedTag)
        } else {
            tagsButton.setTitle("Add Tag")
        }
        //println(selectedTag)
    }
    
    

}
