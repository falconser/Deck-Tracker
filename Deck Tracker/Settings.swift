//
//  Settings.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 14/09/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class Settings: UITableViewController {

    @IBOutlet weak var resetButton: UIButton!
    
    let iCloudKeyStore = NSUbiquitousKeyValueStore()
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let defaults = UserDefaults.standard

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc @IBAction func resetButtonPressed(_ sender:UIButton) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Full reset", message: "What do you want to delete ?", preferredStyle: .alert)
        
        // Create the actions
        let resetAllAction = UIAlertAction(title: "Reset everything", style: .destructive) {
            UIAlertAction in
            
            // Delete from UserDefaults
            self.defaults.removeObject(forKey: "List of games")
            self.groupDefaults?.removeObject(forKey: "List of decks")
            self.groupDefaults?.removeObject(forKey: "Selected Deck Name")
            self.groupDefaults?.removeObject(forKey: "All Tags")
            TrackerData.sharedInstance.listOfGames = []
            TrackerData.sharedInstance.listOfDecks = []
            TrackerData.sharedInstance.listOfTags = []
            
            // Sync
            self.groupDefaults?.synchronize()
            self.defaults.synchronize()
            
            // Remove from iCloud as well
            self.iCloudKeyStore.removeObject(forKey: "iCloud list of decks")
            self.iCloudKeyStore.removeObject(forKey: "iCloud list of games")
            self.iCloudKeyStore.removeObject(forKey: "iCloud All Tags")
            self.iCloudKeyStore.removeObject(forKey: "iCloud Selected Deck Name")
            self.iCloudKeyStore.synchronize()
            
            NSLog("Reset everything pressed")
        }
        
        let resetGamesAction = UIAlertAction(title: "Reset all games", style: .destructive) {
            UIAlertAction in
            
            // Delete from UserDefaults
            self.defaults.removeObject(forKey: "List of games")
            TrackerData.sharedInstance.listOfGames = []
            // Sync
            self.defaults.synchronize()
            
            // Remove from iCloud as well
            self.iCloudKeyStore.removeObject(forKey: "iCloud list of games")
            self.iCloudKeyStore.synchronize()
            
            NSLog("Reset all games pressed")
            
        }
        
        let resetGamesAndDecksAction = UIAlertAction(title: "Reset all games AND all decks", style: .destructive) {
            UIAlertAction in
            
            // Delete from UserDefaults
            self.defaults.removeObject(forKey: "List of games")
            self.groupDefaults?.removeObject(forKey: "List of decks")
            self.groupDefaults?.removeObject(forKey: "Selected Deck Name")
            TrackerData.sharedInstance.listOfGames = []
            TrackerData.sharedInstance.listOfDecks = []
            // Sync
            self.groupDefaults?.synchronize()
            self.defaults.synchronize()
            
            // Remove from iCloud as well
            self.iCloudKeyStore.removeObject(forKey: "iCloud list of decks")
            self.iCloudKeyStore.removeObject(forKey: "iCloud list of games")
            self.iCloudKeyStore.removeObject(forKey: "iCloud Selected Deck Name")
            self.iCloudKeyStore.synchronize()
            
            NSLog("Reset all games AND decks pressed")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(resetAllAction)
        alertController.addAction(resetGamesAction)
        alertController.addAction(resetGamesAndDecksAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }
    
    // When selecting the table cell from the first section have reset all button press
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            resetButtonPressed(self.resetButton)
        }
    }
}
