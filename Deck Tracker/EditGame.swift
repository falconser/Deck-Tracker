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
    var selectedGame:Game = Game(newID: 1, newDate: Date(), newPlayerDeckName: "1", newPlayerDeckClass: "1", newOpponentDeck: "1", newCoin: true, newWin: true, newTag: "")
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
    
    // Puts saved date on label
    func putSavedDateOnLabel() {
        let editedDate:Date! = defaults.object(forKey: "Saved Edited Date") as? Date
        if editedDate != nil {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let dateString = formatter.string(from: editedDate)
            dateLabel.text = "Date: " + dateString
        } else {
            let savedDate: String = selectedGame.getDate()
            dateLabel.text = "Date: " + savedDate
        }

    }
    
    // Puts selected deck on label
    func putSavedPlayerDeckOnLabel() {
        if let editedDeckName = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.string(forKey:"Edited Deck Name") {
            playerDeckLabel.text = "Your deck: " + editedDeckName
        } else {
            let savedPlayedDeck = selectedGame.playerDeckName
            playerDeckLabel.text = "Your deck: " + savedPlayedDeck
        }

    }
    
    // Puts opponent class on label
    func putSavedOpponentClassOnLabel() {
        if let editedOpponentClass = defaults.string(forKey:"Edited Opponent Class") {
            opponentDeckLabel.text = "Opponent's Class: " + editedOpponentClass
        } else {
            opponentDeckLabel.text = "Opponent's Class: " + selectedGame.opponentDeck
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
        if editedDate != nil {
            dateLabel.text = "Date: " + EditDate.sharedInstance.dateToString(editedDate!)
        } else {
            dateLabel.text = "Date: " + selectedGame.getDate()
        }
    }
    
    // Puts edited deck name on label
    func putSelectedPlayerDeckOnLabel() {
        let savedDeck = selectedGame.playerDeckName
        let editedDeck = defaults.string(forKey:"Edited Deck Name")
        if editedDeck == nil {
            playerDeckLabel.text = "Your deck: " + savedDeck
        } else {
            playerDeckLabel.text = "Your deck: " + editedDeck!
        }
    }
    
    // Puts edited opponent class on label
    func putSelectedOpponentClassOnLabel() {
        let savedOpponentClass = selectedGame.opponentDeck
        //println(savedOpponentClass)
        let editedOpponentClass = defaults.string(forKey:"Edited Opponent Class")
        //println(editedOpponentClass)
        if editedOpponentClass == nil {
            opponentDeckLabel.text = "Opponent's Class: " + savedOpponentClass
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
            editedPlayerDeckName = selectedGame.playerDeckName
        }
        
        var editedPlayerDeckClass = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")!.string(forKey:"Edited Deck Class") as String?
        if editedPlayerDeckClass == nil {
            editedPlayerDeckClass = selectedGame.playerDeckClass
        }
        
        var editedOpponentClass = defaults.string(forKey:"Edited Opponent Class")
        if editedOpponentClass == nil {
            editedOpponentClass = selectedGame.opponentDeck
        }
        
        let editedCoin = coinSwitch.isOn
        
        let editedWin = winSwitch.isOn
        
        let editedTag = defaults.string(forKey:"Edited Selected Tag") as String!
       
        // Create a new Game object
        let editedGame = Game(newID: editedID, newDate: editedDate!, newPlayerDeckName: editedPlayerDeckName!, newPlayerDeckClass: editedPlayerDeckClass!, newOpponentDeck: editedOpponentClass!, newCoin: editedCoin, newWin: editedWin, newTag: editedTag!)
        
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
