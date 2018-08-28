//
//  DeckTrackerWatch.swift
//  Deck Tracker WatchKit Extension
//
//  Created by Andrei Joghiu on 29/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class DeckTrackerWatch: WKInterfaceController {
    
    @IBOutlet var selectDeckButton: WKInterfaceButton!
    @IBOutlet var selectOpponentButton: WKInterfaceButton!
    @IBOutlet var coinSwitch: WKInterfaceSwitch!
    @IBOutlet var winSwitch: WKInterfaceSwitch!
    @IBOutlet var tagsButton: WKInterfaceButton!
    @IBOutlet var saveGameButton: WKInterfaceButton!
        
    let connectivityManager = WatchConnectivityManager()
    
    var game = Game()
    
    override init() {
        super.init()
        connectivityManager.delegate = self
    }
    
    override func willActivate() {
        connectivityManager.activate()
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        // Populates the "Selected Deck", "Opponent Class" and "Tags" buttons
        print("Watch app started")
    }

    func reset() {
        game = Game()
        updateInterface()
    }
    
    func updateInterface() {
        if let deck = game.playerDeck {
            colorCell(classToBeColored: deck.heroClass, button: selectDeckButton, opponent: false, deckName: deck.name)
        }
        
        if game.opponentClass != .Unknown {
            colorCell(classToBeColored: game.opponentClass, button: selectOpponentButton, opponent: true, deckName: "")
            saveGameButton.setTitle("Save Game")
        } else {
            selectOpponentButton.setTitle("Select Opponent")
            saveGameButton.setTitle("Opponent Class Needed!")
        }
        
        if !game.tags.isEmpty {
            tagsButton.setTitle("Tags: " + game.tags.joined(separator: ", "))
        } else {
            tagsButton.setTitle("Add Tag")
        }
    }
    
    @objc @IBAction func saveButtonPressed() {
        guard game.playerDeck != nil else { return }
        guard game.opponentClass != .Unknown else { return }
        game.date = Date()
        connectivityManager.saveGame(game)
        
        reset()
    }
    
    func colorCell (classToBeColored: Class, button:WKInterfaceButton, opponent:Bool, deckName:String) {
        // Colors the cell according to the Class specified
        button.setBackgroundColor(classToBeColored.color())
        let text = opponent ? "Versus: \(classToBeColored)" : "Deck: \(deckName)"
        let attributedTitle = NSAttributedString(string: text,
                                                 attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 15.0)!,
                                                              NSAttributedStringKey.foregroundColor: UIColor.green])
        button.setAttributedTitle(attributedTitle)
    }
    
    
    
    @objc @IBAction func coinSwitchToggled(value: Bool) {
        // Keep track of coin switch
        game.coin = value
    }
    
    
    @objc @IBAction func winSwitchToggled(value: Bool) {
        // Keep track of win switch
        game.win = value
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        var context = [String:Any]()

        if segueIdentifier == "selectDeck" {
            
            if let decksData = connectivityManager.applicationContext["decksList"] as? Data,
                let decks = KeyedUnarchiverMapper.unarchiveObject(with: decksData) as? [Deck]
            {
                context["decksList"] = decks
            }
            
            context["didSelectBlock"] = { (deck: Deck) in
                self.game.playerDeck = deck
                self.updateInterface()
            }
        }
        else if segueIdentifier == "selectTags" {
            if let tagsList = connectivityManager.applicationContext["tagsList"] as? [String] {
                context["tagsList"] = tagsList
            }
            
            context["selectedTags"] = game.tags
            context["didSelectTag"] = { (tag: String) in
                if !self.game.tags.contains(tag) {
                    self.game.tags.append(tag)
                }
                self.updateInterface()
            }
            context["didDeselectTag"] = { (tag: String) in
                if let index = self.game.tags.index(of: tag) {
                    self.game.tags.remove(at: index)
                }
                self.updateInterface()
            }
        }
        else if segueIdentifier == "selectOpponent" {
            context["didSelectBlock"] = { (heroClass: Class) in
                self.game.opponentClass = heroClass
                self.updateInterface()
            }
        }
        return context
    }
}
extension DeckTrackerWatch: WatchConnectivityManagerDelegate {
    func connectivityManager(_ manager: WatchConnectivityManager, didUpdateApplicationContext context: [String : Any]) {
        
        guard let activeDeckData = context["activeDeck"] as? Data else {
            return
        }
        
        if let activeDeck = KeyedUnarchiverMapper.unarchiveObject(with: activeDeckData) as? Deck {
            game.playerDeck = activeDeck
            updateInterface()
        }
    }
}
