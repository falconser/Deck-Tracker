//
//  Graphs.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 18/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class Graphs: UIViewController, PiechartDelegate {

    var total: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var views: [String: UIView] = [:]
        
        var error = Piechart.Slice()
        error.value = 4 / total
        error.color = UIColor.magentaColor()
        error.text = "Error"
        
        var zero = Piechart.Slice()
        zero.value = 6 / total
        zero.color = UIColor.blueColor()
        zero.text = "Zero"
        
        var win = Piechart.Slice()
        win.value = 10 / total
        win.color = UIColor.orangeColor()
        win.text = "Winner"
        
        var piechart = Piechart()
        piechart.delegate = self
        piechart.title = "Service"
        piechart.activeSlice = 2
        piechart.layer.borderWidth = 1
        piechart.slices = [error, zero, win]
        
        piechart.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(piechart)
        views["piechart"] = piechart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[piechart]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-200-[piechart(==200)]", options: nil, metrics: nil, views: views))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setSubtitle(slice: Piechart.Slice) -> String {
        return "\(Int(slice.value * 100))% \(slice.text)"
    }
    
    func setInfo(slice: Piechart.Slice) -> String {
        return "\(Int(slice.value * total))/\(Int(total))"
    }
}
