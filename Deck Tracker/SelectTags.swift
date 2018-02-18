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
    
    // Save to iCloud
    let iCloudKeyStore: NSUbiquitousKeyValueStore = NSUbiquitousKeyValueStore()
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        // Removes the empty rows from view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func readData() {
        allTags = readTags()
    }
    
    @objc @IBAction func plusButtonPressed(_ sender:UIBarButtonItem) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Tag", message: "Enter Tag", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField{ (textField) -> Void in
            textField.placeholder = "Tag name"
            textField.autocapitalizationType = .sentences
        }
        
        //3. Grab the value from the text field, and adds it to the array when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Finish", style: .default, handler: { (action) -> Void in
            let tagToAdd = alert.textFields![0].text
            
            // Check the tag is not already in the list
            let tagAlreadyExists = nil != self.allTags.map { $0.lowercased() }.index{ tagToAdd?.lowercased() == $0 }
            
            if tagAlreadyExists == true {
                let alert = UIAlertView()
                alert.title = "Tag already exists"
                alert.message = "Enter another tag name"
                alert.addButton(withTitle: "OK")
                alert.show()
            } else if tagToAdd == "" {
                let alert = UIAlertView()
                alert.title = "Tag empty"
                alert.message = "Tag cannot be empty"
                alert.addButton(withTitle: "OK")
                alert.show()
            } else {
                self.allTags.append(tagToAdd!)
                //let sortedtags = sorted(self.allTags, <)
                self.allTags.sort()
                //self.allTags = sortedtags
                self.saveAllTags()
                self.readTags()
                self.tableView.reloadData()
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveAllTags() {
        groupDefaults?.set(allTags, forKey: "All Tags")
        groupDefaults?.synchronize()
        
        // Save to iCloud
        iCloudKeyStore.set(allTags, forKey: "iCloud All Tags")
        iCloudKeyStore.synchronize()
    }
    
    @discardableResult
    func readTags() -> [String]{
        if let iCloudTags = iCloudKeyStore.array(forKey: "iCloud All Tags") as? [String] {
            allTags = iCloudTags
        } else if let defaultsTags = groupDefaults?.array(forKey: "All Tags") as? [String] {
            allTags = defaultsTags
        }
        return allTags
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Deletes the row
        if editingStyle == .delete {
            let index = indexPath.row
            allTags.remove(at: index)
            saveAllTags()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
