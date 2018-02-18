//
//  SelectDate.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 8/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class SelectDate: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var didChangeDate: ((Date) -> Void)?
    var selectedDate: Date = Date() {
        didSet {
            if let didChangeDate = didChangeDate {
                didChangeDate(selectedDate)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        datePicker.setDate(selectedDate, animated: false)
    }
    
    @objc @IBAction func datePickerChanged(_ sender:UIDatePicker) {
        selectedDate = datePicker.date
    }
}
