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
    var indexOfSelectedDeck:Int = -1
    
    // Save to iCloud
    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshData()
        
        // Listens for "Deck Selected" and calls refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(DecksList.refreshData), name: NSNotification.Name(rawValue: "DeckSelected"), object: nil)
        
        // Removes the empty rows from view
        decksTable.tableFooterView = UIView(frame: CGRect.zero)
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
        let cell:CustomCell = tableView.dequeueReusableCell(withIdentifier:"Cell") as! CustomCell
        cell.customLabel.text = decksList[indexPath.row].name
        cell.customImage.image = decksList[indexPath.row].heroClass.smallIcon()
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
        saveSelectedDeckID(selectedDeck)
        saveSelectedDeckName(selectedDeck)
        saveSelectedDeckClass(selectedDeck)
        indexOfSelectedDeck = indexPath.row
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    // Saves the selected deck ID in UserDefaults
    func saveSelectedDeckID(_ deck : Deck) {
        groupDefaults?.set(deck.deckID, forKey: "Selected Deck ID")
        groupDefaults?.synchronize()
    }
    
    // Reads the selected deck ID from UserDefaults
    func readSelectedDeckID() -> Int {
        guard let groupDefaults = groupDefaults else {
            return -1
        }
        
        return groupDefaults.integer(forKey:"Selected Deck ID")
    }
    
    // Saves the selected deck name in UserDefaults and iCloud
    func saveSelectedDeckName(_ deck: Deck) {
        groupDefaults?.set(deck.name, forKey: "Selected Deck Name")
        groupDefaults?.synchronize()
        
        iCloudKeyStore.set(deck.name, forKey: "iCloud Selected Deck Name")
        iCloudKeyStore.synchronize()
    }
    
    // Saves the selected deck class
    func saveSelectedDeckClass(_ deck: Deck) {
        
        groupDefaults?.set(deck.heroClass.rawValue, forKey: "Selected Deck Class")
        groupDefaults?.synchronize()
    }
    
    // Returns the selected deck name
    func readSelectedDeckName() -> String {
        var name = ""
        
        if let iCloudName = iCloudKeyStore.string(forKey:"iCloud Selected Deck Name") {
            name = iCloudName
        } else if let defaultsName = groupDefaults?.string(forKey:"Selected Deck Name") {
            name = defaultsName
        }
        
        return name
    }
    
    // Deselects the row if you select another
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    // Refreshes the view after adding a deck
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }
    
    // Reads the data from Data file
    func readData() {
        if TrackerData.sharedInstance.readDeckData() == nil {
            decksList = []
        } else {
            decksList = TrackerData.sharedInstance.listOfDecks
        }
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
        decksTable.reloadData()
        
        // If there is a deck selected get it's index
        let savedUserDefaults = readSelectedDeckID()
        for i in 0 ..< decksList.count {
            if savedUserDefaults == decksList[i].deckID {
                indexOfSelectedDeck = i
                break
            }
        }
    }
}

