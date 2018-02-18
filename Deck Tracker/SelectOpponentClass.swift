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
    

    var classes = ["Warrior", "Paladin", "Shaman", "Hunter", "Druid", "Rogue", "Mage", "Warlock", "Priest"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gets the number of rows to be displayed in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    // Populates the table with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = classes[indexPath.row]
        return cell
    }


    // Selects the row and saves the info so we can add a checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        let selectedClass = classes[indexPath.row]
        saveSelectedOpponentClass(selectedClass)
        readSelectedOpponentClass()
        navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
    }
    
    // Deselects the row if you select another
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    // Saves the selected opponent class in UserDefaults
    func saveSelectedOpponentClass(_ opponentClass: String) {
        defaults.set(opponentClass, forKey: "Opponent Class")
        defaults.synchronize()
    }
    
    // Reads the selected deck ID from UserDefaults
    @discardableResult
    func readSelectedOpponentClass() -> String {
        guard let result = defaults.string(forKey:"Opponent Class") else {
            return ""
        }
        return result
    }
}
