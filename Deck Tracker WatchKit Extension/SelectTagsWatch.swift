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
    var selectedTags:[String] = []
    
    let defaults = UserDefaults.standard
    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    
    var didSelectTag: ((String) -> ())?
    var didDeselectTag: ((String) -> ())?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let dict = context as? [String:Any] {
            if let didSelectTag = dict["didSelectTag"] as? ((String) -> ()) {
                self.didSelectTag = didSelectTag
            }
            if let didDeselectTag = dict["didDeselectTag"] as? ((String) -> ()) {
                self.didDeselectTag = didDeselectTag
            }
            if let tagsList = dict["tagsList"] as? [String] {
                self.tagsList = tagsList
            }
            if let selectedTags = dict["selectedTags"] as? [String] {
                self.selectedTags = selectedTags
            }
        }
    }

    override func willActivate() {
        super.willActivate()
        
        noTagsLabel.setHidden(true)
        reloadTable()
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
            if isSelected(tag: tag) {
                row.groupTable.setBackgroundColor(UIColor.green)
                row.tagLabel.setTextColor(UIColor.black)
            }
        }
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
        guard let index = selectedTags.firstIndex(of: tag) else { return }
        selectedTags.remove(at: index)
        if let didDeselectTag = didDeselectTag {
            didDeselectTag(tag)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let tag = tagsList[rowIndex]
        // Check to see if the button user pressed was selected already or not
        let wasAlreadySelected = isSelected(tag: tag)
        let row = table.rowController(at:rowIndex) as? TagsRow
        
        
        if wasAlreadySelected {
            // If it was already selected then remove the tag from array and color the row
            row?.groupTable.setBackgroundColor(UIColor.black)
            row?.tagLabel.setTextColor(UIColor.white)
            deselectTag(tag)
        } else {
            // If it was not already selected then add it to array and color the row
            row?.groupTable.setBackgroundColor(UIColor.green)
            row?.tagLabel.setTextColor(UIColor.black)
            selectTag(tag)
        }
        
        print("Selected Tags: " + selectedTags.joined(separator: ", "))
    }
}
