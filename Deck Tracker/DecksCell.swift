//
//  DecksCell.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 6/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var customLabel: UILabel!
    @IBOutlet var customImage: UIImageView!
    
    // Creates the cell
    func setCell(labelText:String, imageName:String) {
        self.customLabel.text = labelText
        self.customImage.image = UIImage(named: imageName)
    }

}
