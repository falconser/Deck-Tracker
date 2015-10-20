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
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!

    
    
    
    var total: CGFloat = 100
    var dateIndex = -1
    var deckIndex = -1
    var deckName = ""
    
    static let sharedInstance = Graphs()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x = self.view.frame.width / 2 - 20
        print(x)
        let screenSize:CGRect = UIScreen.mainScreen().bounds
        let width = screenSize.width / 2
        print(width)
        view1.frame = CGRectMake(0, 0, x, x)
        view2.frame = CGRectMake(width, 0, x, x)
   
        //view1.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        
        
        getInitialStatus()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getInitialStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Loads what buttons are pressed
    func getInitialStatus() {
        dateIndex = dateSegment.selectedSegmentIndex
        deckIndex = deckSegment.selectedSegmentIndex
        if deckIndex == 0 {
            //println(deckName)
            if let _ = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String! {
                deckName = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String!
            } else {
                deckName = ""
            }
        } else {
            deckName = "All"
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(dateIndex, forKey: "Date Index")
        NSUserDefaults.standardUserDefaults().setInteger(deckIndex, forKey: "Deck Index")
        NSUserDefaults.standardUserDefaults().setObject(deckName, forKey: "Deck Name")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        //printStatus()
        
        //Notifies the container that a change occured
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)

    }
    
    // Updates when the date button is changed
    @IBAction func dateChanged(sender: UISegmentedControl) {
        switch dateSegment.selectedSegmentIndex {
        case 0:
            dateIndex = 0
            //println("Last 7 days")
        case 1:
            dateIndex = 1
            //println("Last Month")
        case 2:
            dateIndex = 2
            //println("All games")
        default:
            break
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(dateIndex, forKey: "Date Index")
        NSUserDefaults.standardUserDefaults().synchronize()
        //printStatus()
        
        //Notifies the container that a change occured
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)

    }
    
    // Updates when the deck button is changed
    @IBAction func deckChanged(sender: UISegmentedControl) {
        switch deckSegment.selectedSegmentIndex {
        case 0:
            if let _ = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String! {
                deckName = NSUserDefaults(suiteName: "group.Decks")!.stringForKey("Selected Deck Name") as String!
            } else {
                deckName = ""
            }

            //println("Selected Deck")
        case 1:
            deckName = "All"
            //println("All decks")
        default:
            break
        }
        
        //NSUserDefaults.standardUserDefaults().setInteger(deckIndex, forKey: "Deck Index")
        NSUserDefaults.standardUserDefaults().setObject(deckName, forKey: "Deck Name")
        NSUserDefaults.standardUserDefaults().synchronize()
        //printStatus()
        
        //Notifies the container that a change occured
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        
    }
    
    func printStatus() {
        print("Date Index: " + String(dateIndex))
        print("Deck Index: " + String(deckIndex))
        print("Deck Name: " + String(deckName))
    }
    

}