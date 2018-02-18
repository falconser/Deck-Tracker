//
//  SelectDeckWatch.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 3/6/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import WatchKit
import Foundation


class SelectDeckWatch: WKInterfaceController {

    @IBOutlet var deckTable: WKInterfaceTable!
    @IBOutlet var noDeckLabel: WKInterfaceLabel!
    var deckList:[Deck] = []
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        noDeckLabel.setHidden(true)
        loadData()
        reloadTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func loadData() {
        // Loads data from UserDefaults
        let defaults = UserDefaults(suiteName: "group.Decks")!
        if let dict:[NSDictionary] = defaults.object(forKey: "List of decks dictionary") as? [NSDictionary] {
            extractDictToArrayOfDecks(dict)
        }
        
    }
    
    
    func extractDictToArrayOfDecks(_ dict:[NSDictionary]) {
        // Takes the saved dictionary and transforms it into a Deck array
        for i in 0 ..< dict.count {
            let deckName: String = dict[i]["deckName"] as! String
            let deckClass: String = dict[i]["deckClass"] as! String
            let deckID: Int = dict[i]["deckID"] as! Int
            let newDeck = Deck(newDeckID: deckID, newDeckName: deckName, newDeckClass: deckClass)
            deckList.append(newDeck)
        }
    }
    
    
    func reloadTable() {
        // Populates the table
        deckTable.setNumberOfRows(deckList.count, withRowType: "DeckRow")
        
        if deckList.count == 0 {
            noDeckLabel.setHidden(false)
        } else {
            for i in 0 ..< deckList.count {
                if let row = deckTable.rowController(at:i) as? DeckRow {
                    row.deckLabel.setText(deckList[i].getName())
                    row.deckLabel.setTextColor(UIColor.black)
                    
                    // Colors the cells
                    if deckList[i].getClass() == "Warrior" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0xCC0000))
                    } else if deckList[i].getClass() == "Paladin" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0xCCC333))
                    } else if deckList[i].getClass() == "Shaman" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x3366CC))
                    } else if deckList[i].getClass() == "Hunter" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x339933))
                    } else if deckList[i].getClass() == "Druid" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x990000))
                    } else if deckList[i].getClass() == "Rogue" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x666666))
                    } else if deckList[i].getClass() == "Warlock" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x9900CC))
                    } else if deckList[i].getClass() == "Mage" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x009999))
                    } else if deckList[i].getClass() == "Priest" {
                        row.groupTable.setBackgroundColor(UIColorFromRGB(0x999999))
                    }
                }
            }
        }

    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Saves the selected deck and returns to Main View
        //let row = table.rowController(at:rowIndex) as? DeckRow
        let selectedDeck = deckList[rowIndex]
        let defaults = UserDefaults(suiteName: "group.Decks")!
        defaults.set(selectedDeck.getID(), forKey: "Selected Deck ID")
        defaults.set(selectedDeck.getName(), forKey: "Selected Deck Name")
        defaults.set(selectedDeck.getClass(), forKey: "Selected Deck Class")
        defaults.synchronize()
        WKInterfaceController.openParentApplication(["Save Selected Deck" : ""] , reply: { [](reply, error) -> Void in
            })
        self.pop()
    }
}
