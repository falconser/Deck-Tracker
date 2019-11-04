//
//  DateGroupedGamesDataSource.swift
//  Deck Tracker
//
//  Created by Sergey Falcon on 8/29/18.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import Foundation
import UIKit

class DateGroupedGamesListDataSource: NSObject, GamesListDataSource {
    typealias Section = (date: Date, items: [Game])
    
    private lazy var sections:[Section] = []
    
    var gamesList: [Game] = [] {
        didSet {
            
            sections = gamesList.reduce(into: [Int: [Game]]()) { result, game in
                result[game.date.dayNumber, default: [Game]()].append(game)
                }
                .sorted{ $0.key > $1.key}
                .compactMap { (key, value) in
                    value.first.map { ($0.date.morningDate, value) }
            }
        }
    }
    
    func game(at indexPath: IndexPath) -> Game? {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    static private var sectionNameFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .none
        df.dateStyle = .medium
        return df
    }()
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = sections[section].date
        return DateGroupedGamesListDataSource.sectionNameFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier:identifier)
            ?? GamesCell(style: .default, reuseIdentifier: identifier)
        
        if let gameCell = cell as? GamesCell {
            gameCell.game = sections[indexPath.section].items[indexPath.row]
        }
        
        return cell
    }
    
    // Deletes the row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let game = game(at: indexPath) else {
                return
            }
            
            TrackerData.sharedInstance.deleteGame(game)
            

            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            sections[indexPath.section].items.remove(at: indexPath.row)
            
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                sections.remove(at: indexPath.section)
            }
            
            tableView.endUpdates()
            
        }
    }
    
}
