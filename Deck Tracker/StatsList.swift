//
//  StatsList.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 28/4/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class StatsList: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var statsTable: UITableView!
    
    var gamesList:[Game] = []
    var selectedGameArray:[Game] = []
    static let sharedInstance = StatsList()

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readData()
        
        // Listens for "Game Added" and calls refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.refreshData), name: NSNotification.Name(rawValue: "GameAdded"), object: nil)
        
        // Removes the empty rows from view
        statsTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // Cleans stuff up
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Gets the number of rows to be displayed in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    private func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    // Populates the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GamesCell = tableView.dequeueReusableCell(withIdentifier:"Cell") as! GamesCell
        let game = gamesList[indexPath.row]
        cell.dateLabel.text = stringFromDate(game.date)
        cell.playerImage.image = game.playerDeck.heroClass.smallIcon()
        cell.opponentImage.image = game.opponentClass.smallIcon()
        cell.winLabel.text = game.win ? "WON" : "LOSS"
        return cell
    }
    
    // Saves the selected Game so it can display it's info in the next screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = gamesList[indexPath.row]
        selectedGameArray.append(selectedGame)
        saveSelectedGame()
        readSelectedGame()
        // Remove the selected game from Array so everytime there is only one Game in array
        selectedGameArray.removeAll(keepingCapacity: true)
    }
    
    // Saves in UserDefaults
    func saveSelectedGame() {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: selectedGameArray as NSArray)
        defaults.set(archivedObject, forKey: "Selected Game")
        defaults.synchronize()
    }
    
    // Reads the game data and returns a Game object
    @discardableResult
    func readSelectedGame() -> [Game]? {
        if let unarchivedObject = defaults.object(forKey:"Selected Game") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? [Game]
        }
        return nil
    }
    
    // Returns the image depeding on the deck class
    func getImage (_ str:String) -> String {
        
        if str == "Warrior" {
            return "WarriorSmall"
        } else if str == "Paladin" {
            return "PaladinSmall"
        } else if str == "Shaman" {
            return "ShamanSmall"
        } else if str == "Druid" {
            return "DruidSmall"
        } else if str == "Rogue" {
            return "RogueSmall"
        } else if str == "Mage" {
            return "MageSmall"
        } else if str == "Warlock" {
            return "WarlockSmall"
        } else if str == "Priest" {
            return "PriestSmall"
        } else if str == "Hunter" {
            return "HunterSmall"
        } else {
            return ""
        }
    }
    
    // Reads the games array
    func readData() {
        if TrackerData.sharedInstance.readGameData() == nil {
            gamesList = []
        } else {
            gamesList = TrackerData.sharedInstance.listOfGames
        }
    }
    
    // Refreshes the view after adding a deck
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshData()
    }

    @objc func refreshData() {
        readData()
        statsTable.reloadData()
    }
    
    // Deletes the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            TrackerData.sharedInstance.deleteGame(index)
            readData()
            self.statsTable.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
