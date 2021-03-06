//
//  Commons.swift
//  Deck Tracker
//
//  Created by Sergey Ischuk on 2/18/18.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgbValue: UInt) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension Date {
    func appStringRepresentation() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    var morningDate: Date {
        var comps = Calendar.current.dateComponents([.day, .month, .year], from: self)
        comps.minute = 0
        comps.second = 0
        comps.hour = 0        
        return Calendar.current.date(from: comps)!
    }
    
    var dayNumber: Int {
        return Int((timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: self))) / (24 * 60 * 60))
    }
}
