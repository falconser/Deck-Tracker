//
//  TagsGraphsCollectionView.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 27/10/15.
//  Copyright © 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "TagsGraphsCollectionCell"

class TagsGraphsCollectionView: UICollectionViewController {
    
    // Date selected by the user and if it's the current deck or all decks
    var dateIndex = -1
    var deckName = ""
    
    let data = ["All", "Warrior", "Paladin", "Shaman", "Hunter", "Druid", "Rogue", "Mage", "Warlock", "Priest", "DemonHunter"]
    // Array of decks filtered by Date / Deck name / Opponent
    var filteredGames:[Game] = []
    // Array of tags sorted alphabetically
    var filteredTags:[String] = []
    // Arrays needed to populate the cells in the collection view
    var winRateArray:[Int] = []
    var gamesWonArray:[Int] = []
    var gamesLostArray:[Int] = []
    var filteredGamesAndTags:[Game] = []
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        getDateIndex()
        getDeckName()
        getGraphsClicked()
        getTagName()
        setupGamesFilteredByTag()
        self.collectionView!.reloadData()
    }
    
    func getDateIndex() {
        dateIndex = defaults.integer(forKey:"Date Index")
    }
    
    func getDeckName() {
        deckName = defaults.string(forKey:"Deck Name") ?? ""
    }
    
    func getGraphsClicked() {
        let indexOfSelectedGraph = defaults.integer(forKey:"Index Of Selected Graph")
        
        let opponentSelected = data[indexOfSelectedGraph]
        
        filteredGames = TrackerData.sharedInstance.getStatisticsGamesTotal(date: dateIndex, deck: deckName, opponent: opponentSelected)
    }
    
    func getTagName() {

        var allTags:[String] = []
        
        for game in filteredGames {
            allTags.append(contentsOf: game.tags)
        }
        
        
        filteredTags = Array(Set(allTags))
        filteredTags.sort()
        
        //print(filteredTags)
    }
    
    func setupGamesFilteredByTag() {
        
        winRateArray = []
        gamesWonArray = []
        gamesLostArray = []
        
        for i in 0 ..< filteredTags.count {
        // Create an array with only the relevant games
            filteredGamesAndTags = []
            
            for game in filteredGames {
                if game.tags.contains(filteredTags[i])  {
                    filteredGamesAndTags.append(game)
                }
            }
            
            getStatistics()
            
        }
        
    }
    
    func getStatistics () {
        var gamesWon = 0
        for game in filteredGamesAndTags {
            if game.win == true {
                gamesWon += 1
            }
        }
        
        let totalGames = filteredGamesAndTags.count
        var winRate = 0.0
        if totalGames != 0 {
            winRate =  Double(gamesWon) / Double(totalGames) * 100
        }
        let winRateInt = Int(winRate)
        
        winRateArray.append(winRateInt)
        gamesWonArray.append(gamesWon)
        let gamesLost = filteredGamesAndTags.count - gamesWon
        gamesLostArray.append(gamesLost)
        
        //print("Filtered Games And Tags: " + String(filteredGamesAndTags))
        //print("Win Rate Array: " + String(winRateArray))
        //print("Games Won Array: " + String(gamesWonArray))
        //print("Games Lost Array: " + String(gamesLostArray))

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredTags.count == 0 {
            return 1
        } else {
            return filteredTags.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TagsGraphsCollectionCell
        
        // Configure the cell
        if filteredTags.count == 0 {
            cell.tagLabel.isHidden = true
            cell.label.text = "No data"
            cell.winInfoLabel.isHidden = true
            cell.layer.borderWidth = 2
        } else {
            cell.tagLabel.text = "Tag: " + String(filteredTags[indexPath.row])
            cell.label.text = String(winRateArray[indexPath.row]) + " %"
            cell.winInfoLabel.text = String(gamesWonArray[indexPath.row]) + " - " + String(gamesLostArray[indexPath.row])
            cell.per = CGFloat(winRateArray[indexPath.row])
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        var cellWidth = (width / 2) - 5
        //print(cellWidth)
        
        if cellWidth > 300 {
            cellWidth = 200
        }
        
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
}
