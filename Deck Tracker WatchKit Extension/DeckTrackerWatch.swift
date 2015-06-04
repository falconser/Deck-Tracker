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
    
    @IBOutlet var selectDeckButton: WKInterfaceButton!
    @IBOutlet var selectOpponentButton: WKInterfaceButton!
    @IBOutlet var coinSwitch: WKInterfaceSwitch!
    @IBOutlet var winSwitch: WKInterfaceSwitch!
    @IBOutlet var saveGameButton: WKInterfaceButton!
    
    
    //var playerDeck:String
    //var opponentClass:String = ""

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        setSelectedDeckButton()
        setOpponentClassButton()
        

    
        
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func saveButtonPressed() {
        
        // Remove saved settings
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Watch Opponent Class")
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func setSelectedDeckButton() {
        let defaults = NSUserDefaults(suiteName: "group.Decks")!
        if let selectedDeckID = defaults.integerForKey("Selected Deck ID") as Int! {
            println(selectedDeckID)
            var selectedDeckName = defaults.stringForKey("Selected Deck Name")!
            println(selectedDeckName)
            var selectedDeckClass = defaults.stringForKey("Selected Deck Class")!
            println(selectedDeckClass)
            selectDeckButton.setTitle(selectedDeckName)
        }

    }
    
    func setOpponentClassButton() {
        if let opponentClass = NSUserDefaults.standardUserDefaults().stringForKey("Watch Opponent Class") {
            //selectOpponentButton.setTitle("Opponent: " + String(opponentClass))
            if opponentClass == "Warrior" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0xCC0000))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Warrior", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Paladin" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0xCCC333))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Paladin", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Shaman" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x3366CC))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Shaman", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Hunter" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x339933))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Hunter", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Druid" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x990000))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Druid", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Rogue" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x666666))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Rogue", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Warlock" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x9900CC))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Warlock", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Mage" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x009999))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Mage", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
                
            } else if opponentClass == "Priest" {
                selectOpponentButton.setBackgroundColor(UIColorFromRGB(0x999999))
                
                var boldFont = UIFont(name: "Helvetica Neue", size: 15.0)!
                var greenColor = UIColor.greenColor()
                var attributeDictionary = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: greenColor]
                var attibuteString = NSAttributedString(string: "Versus: Priest", attributes: attributeDictionary)
                selectOpponentButton.setAttributedTitle(attibuteString)
            }
            
        } else {
            selectOpponentButton.setTitle("Select Opponent")
        }
    }

}
