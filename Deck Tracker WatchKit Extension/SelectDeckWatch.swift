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
        if let context = context as? [String: Any],
            let deckList = context["decksList"] as? [Deck]
        {
            self.deckList = deckList
        }
        
        noDeckLabel.setHidden(true)
        reloadTable()
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
        WCSession.default.transferUserInfo(["Save Selected Deck" : ""])
        self.pop()
    }
}
