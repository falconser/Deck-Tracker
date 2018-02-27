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
    
    let defaults = UserDefaults.standard
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    
    var didSelectBlock: ((String) -> ())?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let dict = context as? [String:Any],
            let didSelectBlock = dict["didSelectBlock"] as? ((String) -> ())
        {
            self.didSelectBlock = didSelectBlock
        }
    }

    override func willActivate() {
        super.willActivate()
        
        noTagsLabel.setHidden(true)
        loadData()
        reloadTable()
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
        guard tagsList.count > 0  else {
            noTagsLabel.setHidden(false)
            return
        }
    
        tagsList.enumerated().forEach{ (i, tag) in
            guard let row = tagsTable.rowController(at:i) as? TagsRow else {
                return
            }
            
            row.tagLabel.setText(tag)
            if tag == selectedTag {
                row.groupTable.setBackgroundColor(UIColor.green)
                row.tagLabel.setTextColor(UIColor.black)
            }
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let tag = tagsList[rowIndex]
        // Check to see if the button user pressed was selected already or not
        let wasAlreadySelected = selectedTag == tag
        
        selectedTag = tag
        
        if let row = table.rowController(at:rowIndex) as? TagsRow {
            if wasAlreadySelected == true {
                // If it was already selected then remove the tag from array and color the row
                row.groupTable.setBackgroundColor(UIColor.black)
                row.tagLabel.setTextColor(UIColor.white)
            } else {
                // If it was not already selected then add it to array and color the row
                row.groupTable.setBackgroundColor(UIColor.green)
                row.tagLabel.setTextColor(UIColor.black)
            }
        }
        print("Selected Tag: " + selectedTag)

        // Save selected tag array
        if let didSelectBlock = didSelectBlock {
            didSelectBlock(selectedTag)
        }
        self.pop()
    }

}
