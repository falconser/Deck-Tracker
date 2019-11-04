//
//  Game.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 4/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

// This class creates games that the user played and won/lost.
import Foundation

class Game : NSObject, NSCoding {
    
    var id:Int = -1
    var playerDeck: Deck?
    var opponentClass: Class = .Unknown
    var coin:Bool = false
    var win:Bool = true
    var date:Date = Date()
    var tags:[String] = []

    init(with deck: Deck? = nil) {
        playerDeck = deck
        super.init()
    }
    
    // Initialize an Game object with the following arguments
    init (newID:Int, newDate:Date, playerDeck:Deck, opponentClass:Class, newCoin:Bool, newWin:Bool, tags:[String]) {
        self.id = newID
        self.playerDeck = playerDeck
        self.opponentClass = opponentClass
        self.coin = newCoin
        self.win = newWin
        self.date = newDate
        self.tags = tags
    }
    
    // Encode and decode the object so it can be stored in UserDefaults
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        if let playerDeck = aDecoder.decodeObject(forKey: "playerDeck") as? Deck {
            self.playerDeck = playerDeck
        }
        else {
            let playerDeckName = aDecoder.decodeObject(forKey: "playerDeckName") as! String
            let playerDeckClass = aDecoder.decodeObject(forKey: "playerDeckClass") as! String
            self.playerDeck = Deck(deckID: -1, name: playerDeckName, heroClass: playerDeckClass)
        }
        
        if let opponentClassName = aDecoder.decodeObject(forKey: "opponentDeck") as? String {
            opponentClass = Class(opponentClassName)
        }
        else {
            opponentClass = .Unknown
        }
        
        coin = aDecoder.decodeBool(forKey: "coin")
        win = aDecoder.decodeBool(forKey: "win")
        date = aDecoder.decodeObject(forKey: "date") as! Date
        if let tags = aDecoder.decodeObject(forKey: "tags") as? [String] {
            self.tags = tags
        }
        else if let tag = aDecoder.decodeObject(forKey: "tag") as? String,
            !tag.isEmpty {
            self.tags = [tag]
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(playerDeck, forKey: "playerDeck")
        aCoder.encode(opponentClass.rawValue, forKey: "opponentDeck")
        aCoder.encode(coin, forKey: "coin")
        aCoder.encode(win, forKey: "win")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(tags, forKey: "tags")
    }
    
    // Returns a string containing all the proprierties of the object
    func toString() -> String {
        return """
        Game number: \(id),
        date: \(date.appStringRepresentation()),
        Player Deck Name: \(String(describing: playerDeck?.name)),
        Opponent Deck: \(opponentClass.rawValue),
        Coin: \(coin),
        Win: \(win),
        Tags: \(tags.joined(separator: ", "))
        """
    }
}
