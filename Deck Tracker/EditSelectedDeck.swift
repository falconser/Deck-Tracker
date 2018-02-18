//
//  EditSelectedDeck.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 14/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import Foundation
import UIKit


class EditSelectedDeck: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationBarDelegate {
    
    @IBOutlet var decksTable: UITableView!
    
    var decksList:[Deck] = []
    var indexOfSelectedDeck:Int = -1
    
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readData()
        
        // If there is a deck selected get it's index
        let savedUserDefaults = readEditedDeckID()
        for i in 0 ..< decksList.count {
            if savedUserDefaults == decksList[i].deckID {
                indexOfSelectedDeck = i
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gets the number of rows to be displayed in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decksList.count
    }
    
    // Populates the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier:"Cell") as! CustomCell
        cell.customLabel.text = decksList[indexPath.row].name
        cell.customImage.image = decksList[indexPath.row].heroClass.smallIcon()
        //cell.accessoryType = UITableViewCellAccessoryType.none
        // If there is a selected deck put a checkmark on it
        if indexPath.row == indexOfSelectedDeck {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    
    // Selects the row and saves the info so we can add a checkmark
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        let selectedDeck = decksList[indexPath.row]
        saveEditedDeckID(selectedDeck)
        readEditedDeckID()
        saveEditedDeckName(selectedDeck)
        readEditedDeckName()
        saveEditedDeckClass(selectedDeck)
        indexOfSelectedDeck = indexPath.row
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // Saves the selected deck ID in UserDefaults
    func saveEditedDeckID(_ deck : Deck) {
        defaults.set(deck.deckID, forKey: "Edited Deck ID")
        defaults.synchronize()
    }
    
    // Reads the selected deck ID from UserDefaults
    @discardableResult
    func readEditedDeckID() -> Int {
        return defaults.integer(forKey:"Edited Deck ID")
    }
    
    // Saves the selected deck name in UserDefaults
    func saveEditedDeckName(_ deck: Deck) {
        groupDefaults?.set(deck.name, forKey: "Edited Deck Name")
        groupDefaults?.synchronize()
    }
    
    // Saves the selected deck class
    func saveEditedDeckClass(_ deck: Deck) {
        groupDefaults?.set(deck.heroClass.rawValue, forKey: "Edited Deck Class")
        groupDefaults?.synchronize()
    }
    
    // Reads the edited deck name
    @discardableResult
    func readEditedDeckName() -> String {
        return groupDefaults?.string(forKey:"Edited Deck Name") ?? ""
    }
    
    // Deselects the row if you select another
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    // Refreshes the view after adding a deck
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        readData()
        decksTable.reloadData()
        
        // If there is a deck selected get it's index
        let savedUserDefaults = readEditedDeckID()
        for i in 0 ..< decksList.count {
            if savedUserDefaults == decksList[i].deckID {
                indexOfSelectedDeck = i
                break
            }
        }
    }
    
    // Reads the data from Data file
    func readData() {
        if TrackerData.sharedInstance.readDeckData() == nil {
            
        } else {
            decksList = TrackerData.sharedInstance.listOfDecks
        }
    }
    
    // Deletes the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            TrackerData.sharedInstance.deleteDeck(index)
            readData()
            self.decksTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

