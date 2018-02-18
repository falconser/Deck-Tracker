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
    
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    
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
        if let dict = groupDefaults?.object(forKey: "List of decks dictionary") as? [NSDictionary] {
            extractDictToArrayOfDecks(dict)
        }
    }
    
    
    func extractDictToArrayOfDecks(_ dict:[NSDictionary]) {
        // Takes the saved dictionary and transforms it into a Deck array
        for i in 0 ..< dict.count {
            let deckName: String = dict[i]["deckName"] as! String
            let deckClass: String = dict[i]["deckClass"] as! String
            let deckID: Int = dict[i]["deckID"] as! Int
            let newDeck = Deck(deckID: deckID, name: deckName, heroClass: deckClass)
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
                    let deck = deckList[i]
                    row.deckLabel.setText(deck.name)
                    row.deckLabel.setTextColor(UIColor.black)
                    row.groupTable.setBackgroundColor(deck.heroClass.color())
                }
            }
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Saves the selected deck and returns to Main View
        //let row = table.rowController(at:rowIndex) as? DeckRow
        let selectedDeck = deckList[rowIndex]
        groupDefaults?.set(selectedDeck.deckID, forKey: "Selected Deck ID")
        groupDefaults?.set(selectedDeck.name, forKey: "Selected Deck Name")
        groupDefaults?.set(selectedDeck.heroClass.rawValue, forKey: "Selected Deck Class")
        groupDefaults?.synchronize()
        WKInterfaceController.openParentApplication(["Save Selected Deck" : ""] , reply: { [](reply, error) -> Void in
            })
        self.pop()
    }
}
