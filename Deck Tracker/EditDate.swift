//
//  EditDate.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 14/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class EditDate: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    static let sharedInstance = EditDate()

    let defaults = UserDefaults.standard

    // Saves edited date
    @objc @IBAction func dateChanged(_ sender:UIDatePicker) {
        let newDate = datePicker.date
        print(newDate)
        saveEditedDate(newDate)
        readDate()
    }
    
    // Saves to UserDefaults
    func saveEditedDate(_ date:Date) {
        defaults.set(date, forKey: "Saved Edited Date")
        defaults.synchronize()
    }
    
    // Reads the edited date
    @discardableResult
    func readDate() -> Date? {
        return defaults.object(forKey: "Saved Edited Date") as? Date
    }
    
    // Returns the edited date to String
    func dateToString(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let dateString = formatter.string(from: date)
        return dateString
    }
}
