//
//  AddDeck.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 28/4/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class AddDeck: UIViewController, UITextFieldDelegate, UINavigationBarDelegate {

    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var warriorClassButton: UIButton!
    @IBOutlet var paladinClassButton: UIButton!
    @IBOutlet var shamanClassButton: UIButton!
    @IBOutlet var hunterClassButton: UIButton!
    @IBOutlet var druidClassButton: UIButton!
    @IBOutlet var rogueClassButton: UIButton!
    @IBOutlet var mageClassButton: UIButton!
    @IBOutlet var warlockClassButton: UIButton!
    @IBOutlet var priestClassButton: UIButton!
    @IBOutlet var demonHunterClassButton: UIButton!
    
    @IBOutlet var classButtons: [UIButton]!
    
    @IBOutlet var deckNameTxtField: UITextField!
    var deckClass:String = ""
    var deckID = 0

    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.deckNameTxtField.delegate = self
    }
    
    // Cancel button is pressed
    @objc @IBAction func cancelButtonPressed(_ sender:UIBarButtonItem) {
        self.dismiss(animated:true, completion: {})
    }
    
    @objc @IBAction func saveButtonPressed(_ sender:UIBarButtonItem) {
        
        // Get the atributes from the user
        let deckName:String = deckNameTxtField.text!
        let deckSelected = selectedDeck()
        
        guard deckSelected != "" && deckName != "" else {
            let alert = UIAlertController(title: "Error",
                                                  message: nil,
                                                  preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            
            
            if deckSelected == "" {
                alert.message = "Please select the class"
            }
            else {
                alert.message = "Please enter a name"
            }
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Loads and increments the deck ID then saves the new ID
        readDeckID()
        deckID += 1
        setDeckID()
        // Create a new Deck object and add it to the deck array
        let deckList = TrackerData.sharedInstance.listOfDecks
        guard nil == deckList.first(where:{ $0.name.lowercased() == deckName.lowercased() }) else {
            let alert = UIAlertController(title: "Deck already exists",
                                          message: "Deck name already exists",
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newDeck = Deck(deckID: deckID, name: deckName, heroClass: deckSelected)
        //println("Added: " + newDeck.toString())
        TrackerData.sharedInstance.addDeck(newDeck)
        self.dismiss(animated:true, completion: {})
        
    }
    
    // Reads the saved Deck ID from iCloud or local storage
    func readDeckID() {
        if let iCloudDeckId = iCloudKeyStore.object(forKey: "iCloud deck ID") as? Int {
            deckID = iCloudDeckId
        } else {
            deckID = defaults.integer(forKey:"Deck ID")
        }
    }
    
    // Saves the Deck ID to iCloud and Local storage
    func setDeckID() {
        defaults.set(deckID, forKey: "Deck ID")
        defaults.synchronize()
        
        iCloudKeyStore.set(deckID, forKey: "iCloud deck ID")
        iCloudKeyStore.synchronize()
    }
    
    @objc @IBAction func classSelected(_ classButton: UIButton) {
        classButtons.forEach { $0.isSelected = false }
        classButton.isSelected = true
    }
    
    // Returns the selected deck class
    func selectedDeck() -> String {
        if warriorClassButton.isSelected == true {
            return "Warrior"
        } else if paladinClassButton.isSelected == true {
            return "Paladin"
        } else if shamanClassButton.isSelected == true {
            return "Shaman"
        } else if hunterClassButton.isSelected == true {
            return "Hunter"
        } else if druidClassButton.isSelected == true {
            return "Druid"
        } else if rogueClassButton.isSelected == true {
            return "Rogue"
        } else if mageClassButton.isSelected == true {
            return "Mage"
        } else if warlockClassButton.isSelected == true {
            return "Warlock"
        } else if priestClassButton.isSelected == true {
            return "Priest"
        } else if demonHunterClassButton.isSelected == true {
            return "DemonHunter"
        } else {
            return ""
        }
    }
    
    
    // Hide keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Hide keyboard when taping outside of it
    //override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    //   self.view.endEditing(true)
    //}
}
