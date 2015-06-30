//
//  EditTags.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 29/6/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class EditTags: UITableViewController {
    
    @IBOutlet var tagsTable: UITableView!
    @IBOutlet var plusButton: UIBarButtonItem!
    

    var notesArray:[String] = []
    var selectedNotesArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readData()
        
        // Removes the empty rows from view
        tagsTable.tableFooterView = UIView(frame: CGRectZero)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return notesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = notesArray[indexPath.row]
        var cellLabel = cell.textLabel?.text as String!
        for var i = 0; i < selectedNotesArray.count; i++ {
            if cellLabel == selectedNotesArray[i] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func readData() {
        notesArray = readNotes()
        //selectedNotesArray = readSelectedNotes()
    }
    
    @IBAction func plusButtonPressed(sender: UIBarButtonItem) {
    }
    
    func readNotes() -> [String] {
        let defaults = NSUserDefaults(suiteName: "group.Decks")!
        if let notesTest = defaults.arrayForKey("All Notes") {
            notesArray = defaults.arrayForKey("All Notes") as! [String]
        }
        //println(notesArray)
        return notesArray
    }
    

}