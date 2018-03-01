//
//  Deck.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 5/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

// This class creates decks for the user to manage. 
import Foundation

class Deck : NSObject, NSCoding {
    
    private(set) var name:String
    private(set) var deckID:Int
    private(set) var heroClass: Class
    
    // Initialize a Deck object with arguments
    init (deckID:Int, name:String, heroClass:String) {
        self.name = name
        self.heroClass = .init(heroClass)
        self.deckID = deckID
    }
    
    // Encode and decode so we can store this object in UserDefaults
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "deckName") as! String
        let deckClassString = aDecoder.decodeObject(forKey: "deckClass") as! String
        heroClass = .init(deckClassString)
        deckID = aDecoder.decodeInteger(forKey: "deckID")
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "deckName")
        coder.encode(heroClass.rawValue, forKey: "deckClass")
        coder.encode(deckID, forKey: "deckID")
    }
    
    // Returns a string containing all the proprierties of the object
    func toString() -> String {
        let deckIDString = String(deckID)
        return ("Deck ID: " + deckIDString + " ,name: " + name + " ,class : " + heroClass.rawValue)
    }
    
    // Returns a dictionary with all properties in it
    func getDict() -> NSMutableDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(self.name, forKey: "deckName")
        dict.setValue(self.heroClass.rawValue, forKey: "deckClass")
        dict.setValue(self.deckID, forKey: "deckID")
        return dict
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherDeck = object as? Deck else { return false }
        return name == otherDeck.name && heroClass == otherDeck.heroClass
    }
}
