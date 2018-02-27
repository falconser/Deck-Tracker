//
//  SelectTags.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 26/6/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class SelectTags: UITableViewController {
    
    @IBOutlet var tagsTable: UITableView!
    @IBOutlet var plusButton: UIBarButtonItem!

    var allTags: [String] = []
    var didChangeTag: ((String) -> Void)?
    var selectedTag: String = "" {
        didSet {
            if let didChangeTag = didChangeTag {
                didChangeTag(selectedTag)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
    }
    
    func readData() {
        allTags = TrackerData.sharedInstance.listOfTags
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return allTags.count
    }
    
    // Configures the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let tag = allTags[indexPath.row]
        cell.textLabel?.text = tag
        cell.accessoryType = tag == selectedTag ? .checkmark : .none
        return cell
    }
    
    // Selects the row and saves the info so we can add a checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectedTag = cell?.textLabel?.text ?? ""
        navigationController?.popViewController(animated: true)
    }
    
    @objc @IBAction func plusButtonPressed(_ sender:UIBarButtonItem) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Tag", message: "Enter Tag", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { textField in
            textField.placeholder = "Tag name"
            textField.autocapitalizationType = .sentences
        }
        
        //3. Grab the value from the text field, and adds it to the array when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { action in

            guard let tagToAdd = alert.textFields![0].text, tagToAdd != "" else {
                let alert = UIAlertController(title: "Tag empty",
                                              message: "Tag cannot be empty",
                                              preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                return
            }
            guard !self.allTags.contains(where: { $0.lowercased() == tagToAdd.lowercased() }) else {
                let alert = UIAlertController(title: "Tag already exists",
                                              message: "Enter another tag name",
                                              preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .cancel))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            TrackerData.sharedInstance.addTag(tagToAdd)
            self.readData()
            self.tableView.reloadData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Deletes the row
        if editingStyle == .delete {
            let tag = allTags[indexPath.row]
            tableView.deleteRows(at: [indexPath], with: .fade)
            TrackerData.sharedInstance.deleteTag(tag)
        }
    }
    
    
}
