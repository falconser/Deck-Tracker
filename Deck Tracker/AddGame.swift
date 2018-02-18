//
//  AddGame.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 7/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

class AddGame: UITableViewController, UINavigationBarDelegate  {
    
    @IBOutlet var addGameList: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var dateCell: UITableViewCell!
    @IBOutlet var dateCellLabel: UILabel!
    @IBOutlet var playerDeckCell: UITableViewCell!
    @IBOutlet var playerDeckLabel: UILabel!
    @IBOutlet var opponentDeckCell: UITableViewCell!
    @IBOutlet var opponentDeckLabel: UILabel!
    @IBOutlet var coinCell: UITableViewCell!
    @IBOutlet var coinCellLabel: UILabel!
    @IBOutlet var coinCellSwitch: UISwitch!
    @IBOutlet var winCell: UITableViewCell!
    @IBOutlet var winCellLabel: UILabel!
    @IBOutlet var winCellSwitch: UISwitch!
    @IBOutlet weak var tagsLabel: UILabel!

    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let iCloudKeyStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore()
    let defaults = UserDefaults.standard
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Populates the rows with data
        putSelectedDateOnLabel()
        putSelectedDeckNameOnLabel()
        putSelectedOpponentClassOnLabel()
        putTagLabel()
    }
    
    // Puts the selected date on the date label
    func putSelectedDateOnLabel() {
        dateCellLabel.text = "Date: " + string(from: game.date)
    }

    // Puts the tags on the Tags Label
    func putTagLabel() {
        tagsLabel.text = game.tag.isEmpty ? "Add Tags" : ("Tags: " + game.tag)
    }
    
    // Reads the selected deck name from iCloud or UserDefaults
    func readSelectedDeckName() -> String {
        var name = ""
        if let iCloudName = iCloudKeyStore.string(forKey:"iCloud Selected Deck Name") {
            name = iCloudName
        } else if let defaultsName = groupDefaults?.string(forKey:"Selected Deck Name") {
            name = defaultsName
        }
        
        return name
    }
    
    // Gets the selected deck from UserDefaults and puts it on the label
    func putSelectedDeckNameOnLabel() {
        let selectedDeck = readSelectedDeckName()
        if selectedDeck == "" {
            playerDeckLabel.text = "You need to select a deck first"
        } else {
            playerDeckLabel.text = "Your deck: " + selectedDeck
        }
    }
    
    
    // Puts opponent's class in UserDefaults
    func putSelectedOpponentClassOnLabel() {
        if case .Unknown = game.opponentClass {
            opponentDeckLabel.text = "Select Opponent's Class"
        }
        else {
            opponentDeckLabel.text = "Opponent's class: " + game.opponentClass.rawValue
        }
    }
    

    // Have the nav bar show ok.
    // You need to crtl+drag the nav bar to the view controller in storyboard to create a delegate
    // Then add "UINavigationBarDelegate" to the class on top
    // And move the nav bar 20 points down
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return .topAttached
    }
    
    
    @objc @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated:true, completion: {})
    }
    
    
    func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    @objc @IBAction func saveButtonPressed(_ sender:UIBarButtonItem) {
        // Gets all the atributes for a new Game
        let newGameID = newGameGetID()
        let newGameDate = game.date
        
        // Gets the selected deck name
        var newGamePlayerDeckName = ""
        if let icloudValue = iCloudKeyStore.string(forKey:"iCloud Selected Deck Name") {
            newGamePlayerDeckName = icloudValue
        } else if let defaultsValue = groupDefaults?.string(forKey:"Selected Deck Name") {
            newGamePlayerDeckName = defaultsValue
        }
        
        let newGamePlayerDeckClass = groupDefaults?.string(forKey:"Selected Deck Class") as String?
        let opponentClass = game.opponentClass
        let newGameCoin = coinCellSwitch.isOn
        let newGameWin = winCellSwitch.isOn
        let newGameTag = game.tag
        let playerDeck = Deck(deckID: -1, name: newGamePlayerDeckName, heroClass: newGamePlayerDeckClass!)
        
        if newGamePlayerDeckName != "" && game.opponentClass != .Unknown {
            
            // Adds a new game
            let newGame = Game(newID: newGameID, newDate: newGameDate, playerDeck: playerDeck, opponentClass: opponentClass, newCoin: newGameCoin, newWin: newGameWin, newTag: newGameTag)
            // Add to Data class file
            TrackerData.sharedInstance.addGame(newGame)
            self.dismiss(animated:true, completion: {})
            
            // Crashlytics custom events
            Answers.logCustomEvent(withName: "New game added",
                customAttributes: [
                    "Deck Name": newGamePlayerDeckName,
                    "Deck Class": newGamePlayerDeckClass!,
                    "Opponent Class": game.opponentClass.rawValue,
                    "Win": newGameWin ? "Win" : "Loss",
                    "Tag": newGameTag.isEmpty ? "No tag" : newGameTag,
                    "Added from": UIDevice.current.model
                ])
            
        } else {
            let alert = UIAlertView()
            alert.title = "Missing Info"
            alert.addButton(withTitle: "OK")

            if newGamePlayerDeckName == "" {
                alert.message = "You need to select a deck"
            } else if game.opponentClass == .Unknown {
                alert.message = "You need to select your opponent's class"
            } else {
                alert.message = "You need to enter all required info"
            }
            alert.show()
        }
    }
    
    // Gets the ID for a new Game
    func newGameGetID () -> Int {
        var matchesCount = (iCloudKeyStore.object(forKey: "iCloud Matches Count") as? Int) ?? defaults.integer(forKey:"Matches Count")
        matchesCount += 1
        
        defaults.set(matchesCount, forKey: "Matches Count");
        defaults.synchronize()
        iCloudKeyStore.set(matchesCount, forKey: "iCloud Matches Count")
        iCloudKeyStore.synchronize()
        
        return matchesCount
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectOpponent = segue.destination as? SelectOpponentClass {
            selectOpponent.selectedClass = game.opponentClass
            selectOpponent.onSelectionUpdate = { [weak self] (selectedClass: Class?) in
                self?.game.opponentClass = selectedClass ?? .Unknown
            }
        }
        else if let selectDate = segue.destination as? SelectDate {
            selectDate.selectedDate = game.date
            selectDate.didChangeDate = { [weak self] (date: Date) in
                self?.game.date = date
            }
        }
        else if let tagsViewController = segue.destination as? SelectTags {
            tagsViewController.selectedTag = game.tag
            tagsViewController.didChangeTag = {[weak self] (tag: String) in
                self?.game.tag = tag
            }
        }
    }
}
