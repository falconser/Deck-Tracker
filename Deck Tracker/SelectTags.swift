//
//  SelectTags.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 26/6/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class SelectTags: UITableViewController {
    
    var allTags: [String] = []
    var didSelectTag: ((String) -> Void)?
    var didDeselectTag: ((String) -> Void)?
    var selectedTags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Removes the empty rows from view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readData()
        tableView.reloadData()
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
        cell.accessoryType = isSelected(tag: tag) ? .checkmark : .none
        return cell
    }
    
    // Selects the row and saves the info so we can add a checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tag = allTags[indexPath.row]
        
        if isSelected(tag: tag) {
            deselectTag(tag)
        }
        else {
            selectTag(tag)
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = isSelected(tag: tag) ? .checkmark : .none
    }
    
    private func isSelected(tag: String) -> Bool {
        return selectedTags.contains(tag)
    }
    
    private func selectTag(_ tag: String) {
        guard !isSelected(tag: tag) else { return }
        selectedTags.append(tag)
        if let didSelectTag = didSelectTag {
            didSelectTag(tag)
        }
    }
    
    private func deselectTag(_ tag: String) {
        guard let index = selectedTags.index(of: tag) else { return }
        selectedTags.remove(at: index)
        if let didDeselectTag = didDeselectTag {
            didDeselectTag(tag)
        }
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
            deselectTag(tag)
            tableView.deleteRows(at: [indexPath], with: .fade)
            TrackerData.sharedInstance.deleteTag(tag)
        }
    }
}
