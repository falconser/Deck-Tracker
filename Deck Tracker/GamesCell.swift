//
//  GamesCell.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 11/5/15.
//  Copyright (c) 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class GamesCell: UITableViewCell {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var playerImage: UIImageView!
    @IBOutlet var opponentImage: UIImageView!
    @IBOutlet var coinLabel: UILabel!
    @IBOutlet var winLabel: UILabel!
    
    
    
    @IBOutlet var game: Game? {
        didSet {
            playerImage.image = game?.playerDeck?.heroClass.smallIcon()
            opponentImage.image = game?.opponentClass.smallIcon()
            dateLabel.text = game != nil ? string(from: game!.date) : ""
            winLabel.text = game != nil ? (game!.win ? "WON" : "LOSS") : ""
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        game = nil
    }
    
    private func string(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
}
