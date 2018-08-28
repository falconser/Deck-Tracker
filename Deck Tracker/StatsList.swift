//
//  StatsList.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 28/4/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit
protocol GamesListDataSource: UITableViewDataSource {
    var gamesList: [Game] { get set }
    func game(at indexPath: IndexPath) -> Game?
}

class StatsList: UIViewController, UINavigationBarDelegate, UITableViewDelegate {
    
    @IBOutlet var statsTable: UITableView!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    var dataSource: GamesListDataSource = DateGroupedGamesListDataSource()
    
    static let sharedInstance = StatsList()

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statsTable.dataSource = dataSource
        
        // Removes the empty rows from view
        statsTable.tableFooterView = UIView(frame: CGRect.zero)
        
        readData()
        
        // Listens for "Game Added" and calls refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.refreshData), name: NSNotification.Name(rawValue: "GameAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.updateNewGameButtonState), name: NSNotification.Name(rawValue: "DeckAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StatsList.updateNewGameButtonState), name: NSNotification.Name(rawValue: "DeckRemoved"), object: nil)

        updateNewGameButtonState()
    }
    
    // Cleans stuff up
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Reads the games array
    func readData() {
        dataSource.gamesList = TrackerData.sharedInstance.listOfGames
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
        refreshPlaceholderView()
    }
    
    
    @IBAction func unwindToStatList(unwindSegue: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "game.edit",
            let addGameVC = segue.destination as? GameDetailsViewController
        {
            if let selectedIndex = statsTable.indexPathForSelectedRow,
                let game = dataSource.game(at: selectedIndex)
            {
                addGameVC.navigationItem.title = "Game Details"
                addGameVC.game = game
                addGameVC.isNewGame = false
                statsTable.deselectRow(at: selectedIndex, animated: false)
            }
        }
    }

    @objc func updateNewGameButtonState() {
        newGameButton.isEnabled = TrackerData.sharedInstance.listOfDecks.count > 0
    }
    
    fileprivate func refreshPlaceholderView() {
        if statsTable.numberOfRows(inSection: 0) < 1 {
            statsTable.backgroundView = PlaceholderView(with: PlaceholderText.noAnyGame)
        }
        else {
            statsTable.backgroundView = nil
        }
    }
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        refreshPlaceholderView()
    }
}
