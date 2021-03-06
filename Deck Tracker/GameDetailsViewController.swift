//
//  AddGame.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 7/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class GameDetailsViewController: UITableViewController, UINavigationBarDelegate  {
    
    @IBOutlet var addGameList: UITableView!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var dateCell: UITableViewCell!
    @IBOutlet var dateCellLabel: UILabel?
    @IBOutlet var playerDeckCell: UITableViewCell!
    @IBOutlet var playerDeckLabel: UILabel?
    @IBOutlet var opponentDeckCell: UITableViewCell!
    @IBOutlet var opponentDeckLabel: UILabel?
    @IBOutlet var coinCell: UITableViewCell!
    @IBOutlet var coinCellLabel: UILabel!
    @IBOutlet var coinCellSwitch: UISwitch! {
        didSet {
            if let coinSwitch = coinCellSwitch {
                coinSwitch.addTarget(self, action: #selector(GameDetailsViewController.didChangeCoinValue(sender:)), for: .valueChanged)
            }
        }
    }
    @IBOutlet var winCell: UITableViewCell!
    @IBOutlet var winCellLabel: UILabel!
    @IBOutlet var winCellSwitch: UISwitch! {
        didSet {
            if let winSwitch = winCellSwitch {
                winSwitch.addTarget(self, action: #selector(GameDetailsViewController.didChangeWinValue(sender:)), for: .valueChanged)
            }
        }
    }
    @IBOutlet weak var tagsLabel: UILabel?

    var game: Game
    var isNewGame: Bool = true
    init(with game: Game? = nil) {
        self.game = game ?? Game(with: TrackerData.sharedInstance.activeDeck!)
        self.isNewGame = game != nil
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        game = Game(with: TrackerData.sharedInstance.activeDeck!)
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        putSelectedDateOnLabel()
        putSelectedDeckNameOnLabel()
        putSelectedOpponentClassOnLabel()
        putTagLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Populates the rows with data
        putSelectedDateOnLabel()
        putSelectedDeckNameOnLabel()
        putSelectedOpponentClassOnLabel()
        putTagLabel()
        winCellSwitch.isOn = game.win
        coinCellSwitch.isOn = game.coin
    }
    
    // Puts the selected date on the date label
    func putSelectedDateOnLabel() {
        dateCellLabel?.text = "Date: " + game.date.appStringRepresentation()
    }

    // Puts the tags on the Tags Label
    func putTagLabel() {
        tagsLabel?.text = game.tags.isEmpty ? "Add Tags" : ("Tags: " + game.tags.joined(separator: ", "))
    }
    
    // Gets the selected deck from UserDefaults and puts it on the label
    func putSelectedDeckNameOnLabel() {
        let selectedDeck = game.playerDeck?.name ?? ""
        if selectedDeck == "" {
            playerDeckLabel?.text = "You need to select a deck first"
        } else {
            playerDeckLabel?.text = "Your deck: " + selectedDeck
        }
    }
    
    // Puts opponent's class in UserDefaults
    func putSelectedOpponentClassOnLabel() {
        if case .Unknown = game.opponentClass {
            opponentDeckLabel?.text = "Select Opponent's Class"
        }
        else {
            opponentDeckLabel?.text = "Opponent's class: " + game.opponentClass.rawValue
        }
    }
    

    // Have the nav bar show ok.
    // You need to crtl+drag the nav bar to the view controller in storyboard to create a delegate
    // Then add "UINavigationBarDelegate" to the class on top
    // And move the nav bar 20 points down
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return .topAttached
    }
    
    @objc @IBAction func saveButtonPressed(_ sender:UIBarButtonItem) {
        guard let deck = game.playerDeck, deck.name.isEmpty == false, game.opponentClass != .Unknown else {
            let alert = UIAlertController(title: "Missing Info", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
            
            if game.playerDeck == nil {
                alert.message = "You need to select a deck"
            } else if game.opponentClass == .Unknown {
                alert.message = "You need to select your opponent's class"
            } else {
                alert.message = "You need to enter all required info"
            }
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Add to Data class file
        if isNewGame {
            TrackerData.sharedInstance.addGame(game)
        }
        else {
            TrackerData.sharedInstance.editGame(game)
        }
    
        self.performSegue(withIdentifier: "unwind.statList", sender: self)
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
            tagsViewController.selectedTags = game.tags
            tagsViewController.didSelectTag = {[weak self] (tag: String) in
                self?.game.tags.append(tag)
            }
            tagsViewController.didDeselectTag = {[weak self] (tag: String) in
                if let index = self?.game.tags.firstIndex(of: tag) {
                    self?.game.tags.remove(at: index)
                }
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
