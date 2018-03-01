//
//  GraphsCollectionView.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 22/10/15.
//  Copyright © 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GraphsCollectionCell"

@IBDesignable
class GraphsCollectionView: UICollectionViewController {
    private enum DateFilterOption: Int {
        case lastWeek = 0
        case lastMonth = 1
        case everyDate = 2
        
        var startDate: Date {
            switch self {
            case .lastWeek:
                return Date(timeIntervalSinceNow: -7 * 24 * 60 * 60)
            case .lastMonth:
                return Date(timeIntervalSinceNow: -30 * 24 * 60 * 60)
            case .everyDate:
                return Date.distantPast
            }
        }
    }
    private struct StatsItem {
        let opponentClass: Class?
        let wins: Int
        let losses: Int
        var totalGames: Int { return wins + losses }
        var winRate: Double {
            let games = wins + losses
            guard games > 0 else { return 0.0 }
            return 100 * Double(wins) / Double(games)
        }
    }
    
    private var statisticData: [StatsItem] = []
    private var dateFilter: DateFilterOption = .lastWeek
    private var focusedDeck: Deck? = nil
    var deckName = ""
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(GraphsCollectionView.loadList(notification:)),name:NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @objc
    func loadList(notification: NSNotification){
        //Gets info on rows and reloads the table view
        loadData()
    }
    
    func loadData() {
        getDateIndex()
        getDeckName()
        getStatistics()
        self.collectionView!.reloadData()
        self.collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func getDateIndex() {
        dateFilter = DateFilterOption(rawValue: defaults.integer(forKey:"Date Index")) ?? .lastWeek
    }
    
    func getDeckName() {
        let deckName = defaults.string(forKey:"Deck Name") ?? ""
        focusedDeck = TrackerData.sharedInstance.listOfDecks.first { $0.name == deckName }
    }
    
    private func getStatistics() {
        let opponentClasses: [Class?] = [nil, .Warrior, .Paladin, .Shaman, .Hunter, .Druid, .Rogue, .Mage, .Warlock, .Priest]
    
        statisticData = opponentClasses.map { getStatisticsVs(opponent: $0) }
    }
    
    private func getStatisticsVs(opponent: Class?) -> StatsItem {
        let filteredGames = TrackerData.sharedInstance.gamesFiltered(byDate: dateFilter.startDate,
                                                                     byDeck: focusedDeck.flatMap{ [$0] },
                                                                     byOpponent: opponent.flatMap{ [$0] })
        let totalGames = filteredGames.count
        let wonGames = filteredGames.filter { $0.win }.count
        let lostGames = totalGames - wonGames
        
        return StatsItem(opponentClass: opponent, wins: wonGames, losses: lostGames)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statisticData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        // Configure the cell
        let stats = statisticData[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GraphsCollectionCell
        cell.versusLabel.text = "vs. \(stats.opponentClass?.rawValue ?? "All")"
        cell.opponentClassImage.image = stats.opponentClass?.smallIcon() ?? UIImage(named: "GenericSmall")
        
        if stats.totalGames == 0 {
            cell.winInfoLabel.text = "No Data"
        } else {
            cell.winInfoLabel.text = "\(String(Int(stats.winRate)))% : (\(String(stats.wins))-\(String(stats.losses)))"
        }
        
        cell.per = CGFloat(stats.winRate)
        
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
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //Save the index of the selected graph
        let indexOfSelectedGraph = indexPath.row
        //print(indexOfSelectedGraph)
        defaults.set(indexOfSelectedGraph, forKey: "Index Of Selected Graph")
        return true
    }
}
