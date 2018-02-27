//
//  KeyedUnarchiverMapper.swift
//  Deck Tracker
//
//  Created by Sergey Ischuk on 2/27/18.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import Foundation

class KeyedUnarchiverMapper: NSObject {
    static func unarchiveObject(with data: Data) -> Any? {
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        let mapper = KeyedUnarchiverMapper()
        unarchiver.delegate = mapper
        
        return unarchiver.decodeObject(forKey: "root")
    }
    
    fileprivate override init() {
        
    }
    
}

extension KeyedUnarchiverMapper: NSKeyedUnarchiverDelegate {
    func unarchiver(_ unarchiver: NSKeyedUnarchiver, cannotDecodeObjectOfClassName name: String, originalClasses classNames: [String]) -> Swift.AnyClass? {
        if name == "Deck_Tracker.Deck" {
            return Deck.self
        }
        else if name == "Deck_Tracker_WatchKit_Extension.Deck" {
            return Deck.self
        }
        else if name == "Deck_Tracker_WatchKit_Extension.Game" {
            return Game.self
        }
        return nil
    }
}
