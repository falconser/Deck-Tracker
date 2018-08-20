//
//  PlaceholderView.swift
//  Deck Tracker
//
//  Created by Andrius Shiaulis on 8.07.2018.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import UIKit

struct PlaceholderText {
    static let noAnyDeck = NSLocalizedString("There is no any deck yet", comment: "placeholder message")
    static let noAnyGame = NSLocalizedString("There is no any game yet", comment: "placeholder message")
}


class PlaceholderView: UILabel {

    // MARK: - Initialization
    
    init(with text: String) {
        super.init(frame: .zero)
        self.setup()
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    fileprivate func setup() {
        self.font = UIFont.preferredFont(forTextStyle: .title1)
        self.textAlignment = .center
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.textColor = .gray
    }
}
