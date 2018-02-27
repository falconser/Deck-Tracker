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
    var didSelectBlock: ((Deck) -> ())?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let context = context as? [String: Any] {
            if let deckList = context["decksList"] as? [Deck] {
                self.deckList = deckList
            }
            if let didSelectBlock = context["didSelectBlock"] as? (Deck)->() {
                self.didSelectBlock = didSelectBlock
            }
        }
        
        noDeckLabel.setHidden(true)
        reloadTable()
    }
    
    func reloadTable() {
        // Populates the table
        deckTable.setNumberOfRows(deckList.count, withRowType: "DeckRow")
        
        guard deckList.count > 0 else {
            noDeckLabel.setHidden(false)
            return
        }
        deckList.enumerated().forEach{ i, deck in
            guard let row = deckTable.rowController(at:i) as? DeckRow else {
                return
                
            }
            row.deckLabel.setText(deck.name)
            row.deckLabel.setTextColor(UIColor.black)
            row.groupTable.setBackgroundColor(deck.heroClass.color())
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Saves the selected deck and returns to Main View
        let deck = deckList[rowIndex]
        if let didSelectBlock = didSelectBlock {
            didSelectBlock(deck)
        }
        self.pop()
    }
}
