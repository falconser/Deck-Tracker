//
//  SelectDeck.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 8/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class SelectDeck: UITableViewController {
    
    @IBOutlet var decksTable: UITableView!
    
    var decksList:[Deck] = []
    var selectedDeck: Deck? = TrackerData.sharedInstance.activeDeck
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
    }
    
    // Gets the number of rows to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksList.count
    }
    
    // Populates the table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let deck = decksList[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = deck.name
        cell.imageView?.image = deck.heroClass.smallIcon()
        cell.accessoryType = deck == selectedDeck ? .checkmark : .none

        return cell
    }
    
    // Selects the row and saves the info so we can add a checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDeck = decksList[indexPath.row]
        TrackerData.sharedInstance.activeDeck = selectedDeck
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Deselects the row if you select another
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    // Refreshes the view after adding a deck
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
        decksTable.reloadData()
    }
    
    // Reads the data from Data file
    func readData() {
        decksList = TrackerData.sharedInstance.listOfDecks
    }
    
    // Deletes the row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            TrackerData.sharedInstance.deleteDeck(index)
            readData()
            self.decksTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
}



