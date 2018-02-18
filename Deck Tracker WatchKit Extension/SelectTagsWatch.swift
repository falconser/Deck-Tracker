//
//  SelectTagsWatch.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 22/08/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import WatchKit
import Foundation


class SelectTagsWatch: WKInterfaceController {

    @IBOutlet weak var tagsTable: WKInterfaceTable!
    @IBOutlet weak var noTagsLabel: WKInterfaceLabel!
    var tagsList:[String] = []
    var selectedTag:String = ""
    var wasAlreadySelected = false
    
    let defaults = UserDefaults.standard
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        noTagsLabel.setHidden(true)
        loadData()
        reloadTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func loadData() {
        // Loads all saved tags and then the already selected by user
        if let testTags = groupDefaults?.object(forKey: "All Tags") as? [String] {
            tagsList = testTags
        }
        if let defaultsTag = defaults.string(forKey:"Selected Tag Watch") {
            selectedTag = defaultsTag
        }
        //println(tagsList)
        //println("Selected tag: " + String(stringInterpolationSegment: selectedTagsArray))
    }
    
    
    func reloadTable() {
        // Populates the table
        tagsTable.setNumberOfRows(tagsList.count, withRowType: "TagRow")
        if tagsList.count == 0 {
            noTagsLabel.setHidden(false)
        } else {
            // Sets the labels text
            for i in 0 ..< tagsList.count {
                if let row = tagsTable.rowController(at:i) as? TagsRow {
                    row.tagLabel.setText(tagsList[i])
                }
                // Set background color to the selected tag
                if tagsList[i] == selectedTag {
                    if let row = tagsTable.rowController(at:i) as? TagsRow {
                        row.groupTable.setBackgroundColor(UIColor.green)
                        row.tagLabel.setTextColor(UIColor.black)
                    }
                }
            }
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        // Saves the selected tag and colors the row
        let row = table.rowController(at:rowIndex) as? TagsRow
        
        wasAlreadySelected = false
        
        // Check to see if the button user pressed was selected already or not
        if selectedTag == tagsList[rowIndex] {
            wasAlreadySelected = true
        }
        
        selectedTag = tagsList[rowIndex]
        
        if wasAlreadySelected == true {
            // If it was already selected then remove the tag from array and color the row
            row!.groupTable.setBackgroundColor(UIColor.black)
            row?.tagLabel.setTextColor(UIColor.white)
        } else {
            // If it was not already selected then add it to array and color the row
            row!.groupTable.setBackgroundColor(UIColor.green)
            row?.tagLabel.setTextColor(UIColor.black)
        }
        print("Selected Tag: " + selectedTag)

        //println(wasAlreadySelected)
        
        // Save selected tag array
        
        defaults.set(selectedTag, forKey: "Selected Tag Watch")
        defaults.synchronize()
        self.pop()
    }

}
