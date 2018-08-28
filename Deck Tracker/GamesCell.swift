//
//  GamesCell.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 11/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class GamesCell: UITableViewCell {
    
    @IBOutlet var resultIndicator: UIView!
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var opponentImage: UIImageView!
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var winLabel: UILabel!
    
    @IBOutlet var game: Game? {
        didSet {
            playerImage.image = game?.playerDeck?.heroClass.smallIcon()
            opponentImage.image = game?.opponentClass.smallIcon()
            winLabel.text = game != nil ? (game!.win ? "WON" : "LOSS") : ""
            resultIndicator.backgroundColor =  game.map {
                $0.win ? UIColor(rgbValue:0x009F6B) : UIColor(rgbValue:0xC40233)                
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        game = nil
    }
    
}
