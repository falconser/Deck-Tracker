//
//  DecksList.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 28/4/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class DecksList: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet var decksTable: UITableView!
    
    var decksList:[Deck] = []
    var didChangeDeck: ((Deck?) -> Void)?
    var selectedDeck: Deck? = TrackerData.sharedInstance.activeDeck {
        didSet {
            if let didChangeDeck = didChangeDeck {
                didChangeDeck(selectedDeck)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Remove table view separators after the last cell
        decksTable.tableFooterView = UIView.init(frame: .zero)
        
        // Listens for "Deck Selected" and calls refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(DecksList.refreshData), name: NSNotification.Name(rawValue: "DeckSelected"), object: nil)
    }
    
    // Refreshes the view after adding a deck
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    // Gets the number of rows to be displayed in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksList.count
    }
    
    // Populates the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deck = decksList[indexPath.row]
        let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier:"Cell") as! CustomCell
        
        cell.customLabel.text = deck.name
        cell.customImage.image = deck.heroClass.smallIcon()
        cell.accessoryType = deck == selectedDeck ? .checkmark : .none

        return cell
    }
    
    // Selects the row and saves the info so we can add a checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        let selectedDeck = decksList[indexPath.row]
        TrackerData.sharedInstance.activeDeck = selectedDeck
        navigationController?.popViewController(animated: true)
    }

    // Deselects the row if you select another
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }

    // Reads the data from Data file
    func readData() {
        decksList = TrackerData.sharedInstance.listOfDecks
    }
    
    // Deletes the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let index = indexPath.row
            
            
            
            // Alert to also delete the games with the deck in them
            // Create the alert controller
            let alertController = UIAlertController(title: "Delete games?", message: "Do you want also to delete all the games recorded with this deck ?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) {
                UIAlertAction in
                NSLog("Yes Pressed")
                
                // Delete the games
                let deckName = self.decksList[index].name
                TrackerData.sharedInstance.deleteAllGamesAssociatedWithADeck(deckName: deckName)
                
                // Delete the deck
                TrackerData.sharedInstance.deleteDeck(index)
                self.readData()
                self.decksTable.deleteRows(at: [indexPath], with: .fade)
                self.refreshPlaceholderView()
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                // Delete the deck
                TrackerData.sharedInstance.deleteDeck(index)
                self.readData()
                self.decksTable.deleteRows(at: [indexPath], with: .fade)
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func refreshData() {
        readData()
        selectedDeck = TrackerData.sharedInstance.activeDeck
        decksTable.reloadData()
        refreshPlaceholderView()

    }
    
    fileprivate func refreshPlaceholderView() {
        if decksTable.numberOfRows(inSection: 0) < 1 {
            decksTable.backgroundView = PlaceholderView(with: PlaceholderText.noAnyGame)
        }
        else {
            decksTable.backgroundView = nil
        }
    }
}

