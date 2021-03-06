//
//  Games.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 27/02/16.
//  Copyright © 2016 Andrei Joghiu. All rights reserved.
//

import XCTest

class Games: Utils {
    
    let gamesTab = XCUIApplication().tabBars.buttons["Stats"]
    
    let settingsButton = XCUIApplication().navigationBars["Games List"].buttons["More Info"]
    let addGameButton = XCUIApplication().navigationBars["Games List"].buttons["Add"]
    let gamesListScreenTitle = XCUIApplication().navigationBars["Games List"].staticTexts["Games List"]
        
    override func setUp() {
        super.setUp()
        app.launch()
        sleep(timer: 1.0)
    }
    
    func testElements() {
        XCTAssert(settingsButton.exists)
        XCTAssert(addGameButton.exists)
        XCTAssert(gamesListScreenTitle.exists)
    }
    

}
