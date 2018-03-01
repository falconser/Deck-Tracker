 //
//  Graphs.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 18/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class Graphs: UIViewController {
    
    @IBOutlet var dateSegment: UISegmentedControl!
    @IBOutlet var deckSegment: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var graphContainerBottomConstraint: NSLayoutConstraint!

    var dateIndex = -1
    var deckIndex = -1
    var deckName = ""

    let groupDefaults = UserDefaults(suiteName: "group.com.falcon.Deck-Tracker.Decks")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInitialStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getInitialStatus()
    }

    // Loads what buttons are pressed
    func getInitialStatus() {
        dateIndex = dateSegment.selectedSegmentIndex
        deckIndex = deckSegment.selectedSegmentIndex
        if deckIndex == 0 {
            if let defaultsName = groupDefaults?.string(forKey:"Selected Deck Name") {
                deckName = defaultsName
            } else {
                deckName = ""
            }
        } else {
            deckName = "All"
        }
        
        defaults.set(dateIndex, forKey: "Date Index")
        defaults.set(deckIndex, forKey: "Deck Index")
        defaults.set(deckName, forKey: "Deck Name")
        defaults.synchronize()
        
        // Notifies the container that a change occured
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    // Updates when the date button is changed
    @objc @IBAction func dateChanged(_ sender:UISegmentedControl) {
        switch dateSegment.selectedSegmentIndex {
        case 0:
            // Last 7 days
            dateIndex = 0
        case 1:
            // Last mont
            dateIndex = 1
        case 2:
            // All games
            dateIndex = 2
        default:
            break
        }
        
        defaults.set(dateIndex, forKey: "Date Index")
        defaults.synchronize()
        //Notifies the container that a change occured
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    // Updates when the deck button is changed
    @objc @IBAction func deckChanged(_ sender:UISegmentedControl) {
        switch deckSegment.selectedSegmentIndex {
        // Selected deck
        case 0:
            if let defaultsName = groupDefaults?.string(forKey:"Selected Deck Name") {
                deckName = defaultsName
            } else {
                deckName = ""
            }
        // All decks
        case 1:
            deckName = "All"
        default:
            break
        }
        
        defaults.set(deckName, forKey: "Deck Name")
        defaults.synchronize()
        //Notifies the container that a change occured
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
    }
}
