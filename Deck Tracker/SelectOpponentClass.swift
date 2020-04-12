//
//  SelectOpponentClass.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 8/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class SelectOpponentClass: UITableViewController {
    
    @IBOutlet var opponentClasses: UITableView!
    
    let classes: [Class] = [.Warrior, .Paladin, .Shaman, .Hunter, .Druid, .Rogue, .Mage, .Warlock, .Priest, .DemonHunter]
    var onSelectionUpdate: ((Class?) -> Void)?
    
    var selectedClass: Class? {
        didSet {
            if let onSelectionUpdate = onSelectionUpdate {
                onSelectionUpdate(selectedClass)
            }
        }
    }
    
    // Gets the number of rows to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    // Populates the table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = classes[indexPath.row].rawValue
        cell.accessoryType = classes[indexPath.row] == selectedClass ? .checkmark : .none
        return cell
    }

    
    // Selects the row and saves the info so we can add a checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        selectedClass = classes[indexPath.row]
        navigationController?.popViewController(animated: true)
    }
    
    // Deselects the row if you select another
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
