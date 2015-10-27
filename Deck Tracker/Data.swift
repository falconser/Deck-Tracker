//
//  Data.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 5/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//


// This class manipulates the data base structure of games/decks
import Foundation

public class Data {
    
    // This is to user Data functions easier in other classes
    static let sharedInstance = Data()
    
    // We create two arrays that will hold our objects
    var listOfGames:[Game] = []
    var listOfDecks:[Deck] = []
    var deckListForPhone:[NSDictionary] = []
    
    // Objects needed to be updated in different functions
    var filteredGames:[Game] = []
    var coinArray:[Game] = []
    
    
    // We initialize the data structure
    init() {
        
        // Check at first install if the game/deck database is empty
        if self.readGameData() == nil {
            print("Game database empty")
            if (self.readDeckData() == nil) {
                print("Decks database empty")
            } else {
                listOfDecks = self.readDeckData()!
            }
        
        } else if self.readDeckData() == nil {
            print("Decks database empty")
            if (self.readGameData() == nil) {
                print("Game database empty")
            } else {
                listOfGames = self.readGameData()!
            }
            
        } else {
            listOfGames = self.readGameData()!
            listOfDecks = self.readDeckData()!
        }
    }
    
    // Adds a game object to the array and save the array in NSUserDefaults
    func addGame (newGame : Game) {
        listOfGames.append(newGame)
        listOfGames.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
        saveGame()
        print("Game added")
    }
    
    // Saves the games array
    func saveGame() {
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(listOfGames as NSArray)
        // Writing in NSUserDefaults
        NSUserDefaults.standardUserDefaults().setObject(archivedObject, forKey: "List of games")
        // Sync
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Reads the game data and returns a Game object
    func readGameData() -> [Game]? {
        //println("Data read")
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("List of games") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Game]
        }
        return nil
    }
    
    // Prints all the games in the array
    func printGameData() {
        for (var i=0; i<listOfGames.count; i++) {
            print(listOfGames[i].toString())
        }
    }
    
    // Adds a deck object to the array
    func addDeck (newDeck: Deck) {
        listOfDecks.append(newDeck)
        saveDict()
        saveDeck()
        print("Deck added")
    }
    
    // Creates a new dict to use with phone
    func saveDict() {
        deckListForPhone.removeAll(keepCapacity: true)
        // Create an dictionary array so we can read this in the shared app group
        for var i = 0; i < listOfDecks.count; i++ {
            let dict: NSMutableDictionary = listOfDecks[i].getDict()
            deckListForPhone.append(dict)
        }
    }
    
    // Adds the decks list to NSUserDefaults
    func saveDeck () {
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(listOfDecks as [Deck])
        let defaults = NSUserDefaults(suiteName: "group.Decks")!
        defaults.setObject(archivedObject, forKey: "List of decks")
        defaults.setObject(deckListForPhone, forKey: "List of decks dictionary")
        defaults.synchronize()
        
    }
    
    // Reads the deck data and returns a Deck object
    func readDeckData() -> [Deck]? {
        let defaults = NSUserDefaults(suiteName: "group.Decks")!
        if let unarchivedObject = defaults.objectForKey("List of decks") as? NSData {
            //NSKeyedUnarchiver.setClass(Deck.self, forClassName: "Deck")
            //NSKeyedArchiver.setClassName("Deck", forClass: Deck.self)
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Deck]
        }
        return nil
    }
    
    // Prints all the decks in the array
    func printDeckData () {
        for (var i=0; i<listOfDecks.count; i++) {
            print(listOfDecks[i].toString())
        }
    }
    
    // Deletes a deck from the array and updates the array
    func deleteDeck(id:Int) {
        listOfDecks.removeAtIndex(id)
        saveDeck()
        print("Deck deleted")
        
    }
    
    // Deletes a game from the array and updates the array
    func deleteGame(id:Int) {
        listOfGames.removeAtIndex(id)
        saveGame()
        print("Game deleted")
    }
    
    // Replaces a game from the array
    func editGame (id:Int, oldGame:Game, newGame:Game) {
        for var i = 0; i < listOfGames.count; i++ {
            if listOfGames[i].getID() == id {
                //printGameData()
                listOfGames.removeAtIndex(i)
                //printGameData()
                listOfGames.insert(newGame, atIndex: i)
                //printGameData()
                listOfGames.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
                saveGame()
            }
        }
        print("Game Edited")
    }
    
    
    
    // Calculates the general win rate of the user (all games)
    func generalWinRate(date:Int, deckName:String) -> Double {
        
        var gamesWon = 0
        var dateArray = getDateArray(date)
        var selectedDeckName = ""
        if let _ = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String! {
            selectedDeckName = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String!
        }

        // If current deck is selected
        if deckName == selectedDeckName {
            filteredGames = []
            for var i = 0; i < dateArray.count; i++ {
                if deckName == dateArray[i].getPlayerDeckName() {
                    filteredGames.append(dateArray[i])
                }
            }
        // If all decks are selected
        } else {
            filteredGames = dateArray
        }
        
        for (var i=0; i<filteredGames.count ; i++) {
            if (filteredGames[i].win == true) {
                gamesWon++
            }
        }
        
        let totalGames = filteredGames.count
        var winRate = 0.0
        if totalGames == 0 {
            return winRate
        } else {
            winRate =  Double(gamesWon) / Double(totalGames) * 100
            return winRate
        }

    }
    
    func generalWinRateCount() -> Int {
        return filteredGames.count
    }
    
    
    // Filters the gamesList array based on the date the user selected
    func getDateArray (date:Int) -> [Game] {
        
        var dateArray:[Game] = []
        // If date is last 7 days
        if date == 0 {
            for var i = 0; i < listOfGames.count; i++ {
                let today = NSDate()
                let lastWeek = today.dateByAddingTimeInterval(-24 * 60 * 60 * 7)
                if listOfGames[i].getNSDate().compare(lastWeek) == NSComparisonResult.OrderedDescending {
                    dateArray.append(listOfGames[i])
                }
            }
            //print("Count for the last 7 days: " + String(dateArray.count))
            return dateArray
            // If date is last month
        } else if date == 1 {
            for var i = 0; i < listOfGames.count; i++ {
                let today = NSDate()
                let lastMonth = today.dateByAddingTimeInterval(-24 * 60 * 60 * 30)
                if listOfGames[i].getNSDate().compare(lastMonth) == NSComparisonResult.OrderedDescending {
                    dateArray.append(listOfGames[i])
                }
            }
            //print("Count for the last month: " + String(dateArray.count))
            return dateArray
            // If date is all
        } else if date == 2 {
            dateArray = listOfGames
            //print("Count for all dates: " + String(dateArray.count))
            return dateArray
        } else {
            print("ERROR!!! Date selection is wrong")
            return dateArray
        }
    }
    
    
    
    func getStatisticsGamesTotal(date:Int, deck:String, opponent:String) -> [Game] {
        var filteredGamesByDate = getDateArray(date)
        var selectedDeckName = ""
        var filteredGamesBySelectedDeck:[Game] = []
        var filteredGamesByOpponent:[Game] = []
        
        if let _ = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String! {
            selectedDeckName = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String!
        }
        
        // If current deck is selected
        if deck == selectedDeckName {
            for var i = 0; i < filteredGamesByDate.count; i++ {
                if deck == filteredGamesByDate[i].getPlayerDeckName() {
                    filteredGamesBySelectedDeck.append(filteredGamesByDate[i])
                }
            }
            // If all decks are selected
        } else {
            filteredGamesBySelectedDeck = filteredGamesByDate
        }

        for game in filteredGamesBySelectedDeck {
            if opponent == "All" {
                filteredGamesByOpponent = filteredGamesBySelectedDeck
            } else if opponent == game.getOpponentDeck() {
                filteredGamesByOpponent.append(game)
            }
        }
        
        //print("Count for date filter: " + String(filteredGamesByDate.count))
        //print("Count for deck filter: " + String(filteredGamesBySelectedDeck.count))
        //print("Count for opponent filter: " + String(filteredGamesByOpponent.count))
        
        
        return filteredGamesByOpponent
    }
    
}
