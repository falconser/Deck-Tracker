//
//  EditGame.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 12/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class EditGame: UITableViewController, UINavigationBarDelegate {
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var dateCell: UITableViewCell!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var playerDeckCell: UITableViewCell!
    @IBOutlet var playerDeckLabel: UILabel!
    @IBOutlet var opponentDeckCell: UITableViewCell!
    @IBOutlet var opponentDeckLabel: UILabel!
    @IBOutlet var coinCell: UITableViewCell!
    @IBOutlet var coinSwitch: UISwitch!
    @IBOutlet var winCell: UITableViewCell!
    @IBOutlet var winSwitch: UISwitch!
    @IBOutlet var tagsLabel: UILabel!
    

    var defaults: UserDefaults = UserDefaults.standard
    var selectedGameArray:[Game] = []
    var selectedGame:Game = Game(newID: 1, newDate: Date(), playerDeck: Deck(deckID: -1, name: "1", heroClass: "1"), opponentClass: .Warrior, newCoin: true, newWin: true, newTag: "")
    static let sharedInstance = EditGame()
    var selectedTag: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedGameArray = StatsList.sharedInstance.readSelectedGame() as [Game]!
        selectedGame = selectedGameArray[0]

        // Populates the screen with data
        populateScreen()
    }
    
    // Populates the screen with latest data
    override func viewDidAppear(_ animated: Bool) {
        // Populates the screen with data
        populateScreen()
    }
    
    
    func populateScreen() {
        // Populates the screen with data
        putSavedDateOnLabel()
        putSavedPlayerDeckOnLabel()
        putSavedOpponentClassOnLabel()
        putSavedCoinStatusOnSwitch()
        putSavedWinStatusOnSwitch()
        putSavedTagOnLabel()
    }
    
    func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    // Puts saved date on label
    func putSavedDateOnLabel() {
        let editedDate  = (defaults.object(forKey: "Saved Edited Date") as? Date)
        let savedDate = selectedGame.date
        dateLabel.text = "Date: " + stringFromDate(editedDate ?? savedDate)
    }
    
    // Puts selected deck on label
    func putSavedPlayerDeckOnLabel() {
        if let editedDeckName = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.string(forKey:"Edited Deck Name") {
            playerDeckLabel.text = "Your deck: " + editedDeckName
        } else {
            let savedPlayedDeck = selectedGame.playerDeck.name
            playerDeckLabel.text = "Your deck: " + savedPlayedDeck
        }

    }
    
    // Puts opponent class on label
    func putSavedOpponentClassOnLabel() {
        if let editedOpponentClass = defaults.string(forKey:"Edited Opponent Class") {
            opponentDeckLabel.text = "Opponent's Class: " + editedOpponentClass
        } else {
            opponentDeckLabel.text = "Opponent's Class: " + selectedGame.opponentClass.rawValue
        }

    }
    
    // Puts the coin status
    func putSavedCoinStatusOnSwitch() {
        coinSwitch.setOn(selectedGame.coin, animated: true)
    }
    
    // Puts the win status
    func putSavedWinStatusOnSwitch() {
        winSwitch.setOn(selectedGame.win, animated: true)
    }
    
    // Puts the selected tag
    func putSavedTagOnLabel() {
        
        selectedTag = selectedGame.tag
        //print("Selected Tag Edit Screen with default tags: " + String(stringInterpolationSegment: selectedTags))
        if let _ = defaults.string(forKey:"Edited Selected Tag") {
            selectedTag = defaults.string(forKey:"Edited Selected Tag") as String!
        }
        defaults.set(selectedTag, forKey: "Edited Selected Tag")
        defaults.synchronize()
        //print("Selected Tag Edit Screen after loading Edited Tags: " + String(stringInterpolationSegment: selectedTags))

        tagsLabel.text = "Tag: " + selectedTag
        
        
        
    }
    
    // Puts the selected date on the date label
    func putSelectedDateOnLabel() {
        let editedDate = EditDate.sharedInstance.readDate()
        //var savedDate = selectedGame.getDate()
        //println("Saved Date:")
        //println(savedDate)
        //println("Edited Date:")
        //println(editedDate)
        let date = editedDate ?? selectedGame.date
        dateLabel.text = "Date: " + stringFromDate(date)
    }
    
    // Puts edited deck name on label
    func putSelectedPlayerDeckOnLabel() {
        let savedDeck = selectedGame.playerDeck.name
        let editedDeck = defaults.string(forKey:"Edited Deck Name")
        if editedDeck == nil {
            playerDeckLabel.text = "Your deck: " + savedDeck
        } else {
            playerDeckLabel.text = "Your deck: " + editedDeck!
        }
    }
    
    // Puts edited opponent class on label
    func putSelectedOpponentClassOnLabel() {
        let editedOpponentClass = defaults.string(forKey:"Edited Opponent Class")
        //println(editedOpponentClass)
        if editedOpponentClass == nil {
            opponentDeckLabel.text = "Opponent's Class: " + selectedGame.opponentClass.rawValue
        } else {
            opponentDeckLabel.text = "Opponent's Class: " + editedOpponentClass!
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc @IBAction func cancelButtonPressed(_ sender:UIBarButtonItem) {
        
        // Remove all edited stats
        UserDefaults.standard.removeObject(forKey: "Selected Game")
        UserDefaults.standard.removeObject(forKey: "Saved Edited Date")
        UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.removeObject(forKey: "Edited Deck Name")
        UserDefaults.standard.removeObject(forKey: "Edited Deck Class")
        UserDefaults.standard.removeObject(forKey: "Edited Opponent Class")
        UserDefaults.standard.removeObject(forKey: "Edited Selected Tag")
        UserDefaults.standard.synchronize()
        self.dismiss(animated:true, completion: {});
    }
    
    @objc @IBAction func saveButtonPressed(_ sender:UIBarButtonItem) {
        
        // Get required atributes to create a new Game
        let editedID = selectedGame.id
        
        var editedDate = EditDate.sharedInstance.readDate()
        if editedDate == nil {
            editedDate = selectedGame.date
        }
        
        var editedPlayerDeckName = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.string(forKey:"Edited Deck Name")
        if editedPlayerDeckName == nil {
            editedPlayerDeckName = selectedGame.playerDeck.name
        }
        
        var editedPlayerDeckClass = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.string(forKey:"Edited Deck Class") as String?
        if editedPlayerDeckClass == nil {
            editedPlayerDeckClass = selectedGame.playerDeck.heroClass.rawValue
        }
        
        var editedOpponentClass = selectedGame.opponentClass
        if let defaultsOpponentsClass = defaults.string(forKey:"Edited Opponent Class") {
            editedOpponentClass = Class(defaultsOpponentsClass)
        }
        
        let editedCoin = coinSwitch.isOn
        
        let editedWin = winSwitch.isOn
        
        let editedTag = defaults.string(forKey:"Edited Selected Tag") as String!
       let playerDeck = Deck(deckID: -1, name: editedPlayerDeckName!, heroClass: editedPlayerDeckClass!)
        // Create a new Game object
        let editedGame = Game(newID: editedID, newDate: editedDate!, playerDeck: playerDeck, opponentClass: editedOpponentClass, newCoin: editedCoin, newWin: editedWin, newTag: editedTag!)
        
        TrackerData.sharedInstance.editGame(editedID, oldGame: selectedGame, newGame: editedGame)
        
        
        // Remove all edited stats
        UserDefaults.standard.removeObject(forKey: "Selected Game")
        UserDefaults.standard.removeObject(forKey: "Saved Edited Date")
        UserDefaults.standard.removeObject(forKey: "Edited Deck Name")
        UserDefaults.standard.removeObject(forKey: "Edited Deck Class")
        UserDefaults.standard.removeObject(forKey: "Edited Opponent Class")
        UserDefaults.standard.removeObject(forKey: "Edited Selected Tag")
        UserDefaults.standard.synchronize()
        self.dismiss(animated:true, completion: {});
    }
}
