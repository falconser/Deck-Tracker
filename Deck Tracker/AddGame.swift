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
    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winCellSwitch.addTarget(self, action: #selector(AddGame.didChangeWinValue(sender:)), for: .valueChanged)
        coinCellSwitch.addTarget(self, action: #selector(AddGame.didChangeCoinValue(sender:)), for: .valueChanged)
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
    
    // Gets the selected deck from UserDefaults and puts it on the label
    func putSelectedDeckNameOnLabel() {
        let selectedDeck = game.playerDeck.name
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
        guard game.playerDeck.name.isEmpty == false, game.opponentClass != .Unknown else {
            let alert = UIAlertView()
            alert.title = "Missing Info"
            alert.addButton(withTitle: "OK")
            
            if game.playerDeck.name == "" {
                alert.message = "You need to select a deck"
            } else if game.opponentClass == .Unknown {
                alert.message = "You need to select your opponent's class"
            } else {
                alert.message = "You need to enter all required info"
            }
            alert.show()
            return
        }
        
        // Add to Data class file
        TrackerData.sharedInstance.addGame(game)
        self.dismiss(animated:true)
        
        // Crashlytics custom events
        Answers.logCustomEvent(withName: "New game added",
                               customAttributes: [
                                "Deck Name": game.playerDeck.name,
                                "Deck Class": game.playerDeck.heroClass.rawValue,
                                "Opponent Class": game.opponentClass.rawValue,
                                "Win": game.win ? "Win" : "Loss",
                                "Tag": game.tag.isEmpty ? "No tag" : game.tag,
                                "Added from": UIDevice.current.model
            ])
    }
    
    @objc func didChangeWinValue(sender: UISwitch) {
        game.win = sender.isOn
    }
    
    @objc func didChangeCoinValue(sender: UISwitch) {
        game.coin = sender.isOn
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
        else if let decksListViewController = segue.destination as? DecksList  {
            decksListViewController.selectedDeck = game.playerDeck
            decksListViewController.didChangeDeck = { [weak self] (deck: Deck?) in
                if let deck = deck {
                    self?.game.playerDeck = deck
                }
            }
        }
    }
}
