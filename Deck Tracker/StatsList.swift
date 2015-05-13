//
//  StatsList.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 28/4/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class StatsList: UIViewController, UINavigationBarDelegate, UITableViewDelegate {
    
    @IBOutlet var statsTable: UITableView!
    
    var gamesList:[Game] = []
    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        readData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Have the nav bar show ok.
    // You need to crtl+drag the nav bar to the view controller in storyboard to create a delegate
    // Then add "UINavigationBarDelegate" to the class on top
    // And move the nav bar 20 points down
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition  {
        return UIBarPosition.TopAttached
    }
    
    // Gets the number of rows to be displayed in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    // Populates the table with data
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        //cell.textLabel?.text = gamesList[indexPath.row].toString()
        let cell:GamesCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! GamesCell
        cell.dateLabel.text = gamesList[indexPath.row].getDate()
        var playerImage = gamesList[indexPath.row].getPlayerDeckClass()
        var playerImageName = getImage(playerImage)
        cell.playerImage.image = UIImage(named: playerImageName)
        var opponentImage = gamesList[indexPath.row].getOpponentDeck()
        var opponentImageName = getImage(opponentImage)
        cell.opponentImage.image = UIImage(named: opponentImageName)
        //cell.coinLabel.text = gamesList[indexPath.row].getCoin()
        cell.winLabel.text = gamesList[indexPath.row].getWinString()
        return cell
    }
    
    // Saves the selected Game so it can display it's info in the next screen
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedGame = gamesList[indexPath.row]
        saveSelectedGameID(selectedGame)
        readSelectedGameID()
        saveSelectedGamePlayerDeckName(selectedGame)
        readSelectedGamePlayerDeckName()
        saveSelectedGameOpponentClass(selectedGame)
        readSelectedGameOpponentClass()
        saveSelectedGameCoinStatus(selectedGame)
        readSelectedGameCoinStatus()
        saveSelectedGameWinStatus(selectedGame)
        readSelectedGameWinStatus()
        //saveSelectedGameDate(selectedGame)
        //readSelectedGameDate()
    }
    
    // Saves the selected game ID
    func saveSelectedGameID(selectedGame:Game) {
        defaults.setInteger(selectedGame.getID(), forKey: "Selected Game ID")
        defaults.synchronize()

    }
    
    // Reads the selected game ID
    func readSelectedGameID() -> Int {
        let id:Int = defaults.integerForKey("Selected Game ID")
        return id
    }
    
    func saveSelectedGamePlayerDeckName(selectedGame:Game) {
        defaults.setObject(selectedGame.getPlayerDeckName(), forKey: "Selected Game Player Deck Name")
        defaults.synchronize()
    }
    
    func readSelectedGamePlayerDeckName() -> String {
        let name:String! = defaults.stringForKey("Selected Game Player Deck Name")
        return name
    }
    
    func saveSelectedGameOpponentClass(selectedGame:Game) {
        defaults.setObject(selectedGame.getOpponentDeck(), forKey: "Selected Game Opponent Class")
        defaults.synchronize()
    }
    
    func readSelectedGameOpponentClass() -> String {
        let name:String! = defaults.stringForKey("Selected Game Opponent Class")
        //println(name)
        return name
    }
    
    func saveSelectedGameCoinStatus(selectedGame:Game) {
        defaults.setObject(selectedGame.getCoin(), forKey: "Selected Game Coin Status")
        defaults.synchronize()
    }
    
    func readSelectedGameCoinStatus() -> Bool {
        let coin:Bool! = defaults.boolForKey("Selected Game Coin Status")
        //println(coin)
        return coin
    }
    
    func saveSelectedGameWinStatus(selectedGame:Game) {
        defaults.setObject(selectedGame.getWin(), forKey: "Selected Game Win Status")
        defaults.synchronize()
    }
    
    func readSelectedGameWinStatus() -> Bool {
        let win:Bool! = defaults.boolForKey("Selected Game Win Status")
        println(win)
        return win
    }
    
    
    // Returns the image depeding on the deck class
    func getImage (str:String) -> String {
        
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
    
    
    
    func readData() {
        if Data.sharedInstance.readGameData() == nil {
            
        } else {
            gamesList = Data.sharedInstance.listOfGames
        }
    }
    
    // Refreshes the view after adding a deck
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        readData()
        statsTable.reloadData()
    }
    
    // Deletes the row
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var index = indexPath.row
            Data.sharedInstance.deleteGame(index)
            readData()
            self.statsTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

}

