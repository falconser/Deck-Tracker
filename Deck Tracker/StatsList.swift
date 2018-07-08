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
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    
    var gamesList:[Game] = []
    static let sharedInstance = StatsList()

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readData()
        
        // Listens for "Game Added" and calls refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.refreshData), name: NSNotification.Name(rawValue: "GameAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.updateNewGameButtonState), name: NSNotification.Name(rawValue: "DeckAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.updateNewGameButtonState), name: NSNotification.Name(rawValue: "DeckRemoved"), object: nil)
        
        // Removes the empty rows from view
        statsTable.tableFooterView = UIView(frame: CGRect.zero)
        
        updateNewGameButtonState()
    }
    
    // Cleans stuff up
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Gets the number of rows to be displayed in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    // Populates the table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = gamesList[indexPath.row]
        let identifier = "Cell"
        let cell =
            tableView.dequeueReusableCell(withIdentifier:identifier)
            ?? GamesCell(style: .default, reuseIdentifier: identifier)
        
        if let gameCell = cell as? GamesCell {
            gameCell.game = game
        }
        
        return cell
    }
    
    // Reads the games array
    func readData() {
        gamesList = TrackerData.sharedInstance.listOfGames
    }
    
    // Refreshes the view after adding a deck
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    @objc func refreshData() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.refreshData()
            }
            return
        }
        
        readData()
        statsTable.reloadData()
    }
    
    // Deletes the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = gamesList[indexPath.row]
            TrackerData.sharedInstance.deleteGame(game)
            readData()
            self.statsTable.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    @IBAction func unwindToStatList(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "game.edit",
            let addGameVC = segue.destination as? GameDetailsViewController
        {
            if let selectedIndex = statsTable.indexPathForSelectedRow {
                addGameVC.navigationItem.title = "Game Details"
                addGameVC.game = gamesList[selectedIndex.row]
                addGameVC.isNewGame = false
                statsTable.deselectRow(at: selectedIndex, animated: false)
            }
        }
    }

    @objc func updateNewGameButtonState() {
        newGameButton.isEnabled = TrackerData.sharedInstance.listOfDecks.count > 0
    }
}
