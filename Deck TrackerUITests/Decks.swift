//
//  Decks.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 29/01/16.
//  Copyright © 2016 Andrei Joghiu. All rights reserved.
//

import XCTest

 class Decks: Utils {
    
    let decksTab = XCUIApplication().tabBars.buttons["Decks"]
    
    let addDeckButton = XCUIApplication().navigationBars["Decks"].buttons["Add"]
    let deckScreenTitle = XCUIApplication().navigationBars["Decks"]
    let cancelButton = XCUIApplication().navigationBars["Add Deck"].buttons["Cancel"]
    let addNewDeckScreenTitle = XCUIApplication().navigationBars["Add Deck"]
    let saveButton = XCUIApplication().navigationBars["Add Deck"].buttons["Save"]
    let textField = XCUIApplication().textFields["Enter deck name"]
    let selectClassLabel = XCUIApplication().staticTexts["Select class:"]
    
    let warriorButton = XCUIApplication().buttons["WarriorSmall"]
    let paladinButton = XCUIApplication().buttons["PaladinSmall"]
    let shamanButton = XCUIApplication().buttons["ShamanSmall"]
    let hunterButton = XCUIApplication().buttons["HunterSmall"]
    let rogueButton = XCUIApplication().buttons["RogueSmall"]
    let druidButton = XCUIApplication().buttons["DruidSmall"]
    let mageButton = XCUIApplication().buttons["MageSmall"]
    let warlockButton = XCUIApplication().buttons["WarlockSmall"]
    let priestButton = XCUIApplication().buttons["PriestSmall"]
    
    let warriorDeck = XCUIApplication().tables.staticTexts["Warrior"]
    let paladinDeck = XCUIApplication().tables.staticTexts["Paladin"]
    let shamanDeck = XCUIApplication().tables.staticTexts["Shaman"]
    let hunterDeck = XCUIApplication().tables.staticTexts["Hunter"]
    let rogueDeck = XCUIApplication().tables.staticTexts["Rogue"]
    let druidDeck = XCUIApplication().tables.staticTexts["Druid"]
    let mageDeck = XCUIApplication().tables.staticTexts["Mage"]
    let warlockDeck = XCUIApplication().tables.staticTexts["Warlock"]
    let priestDeck = XCUIApplication().tables.staticTexts["Priest"]
        
    override func setUp() {
        super.setUp()
        app.launch()
        sleep(timer: 1.0)
        decksTab.tap()
    }
    
    func testElementsExists() {
        elementsDeckTab()
        addDeckButton.tap()
        elementsNewDeckScreen()
    }
    
    func testAddAllDecks() {
        Settings().resetAll()
        decksTab.tap()
        
        addDeck(deckTitle: "Control Warrior", deckClass: "Warrior")
        tapDeck(deckTitle: "Control Warrior")
        addDeck(deckTitle: "Secrets", deckClass: "Paladin")
        addDeck(deckTitle: "Aggro", deckClass: "Shaman")
        addDeck(deckTitle: "Face Hunter", deckClass: "Hunter")
        addDeck(deckTitle: "Midrange", deckClass: "Druid")
        tapDeck(deckTitle: "Midrange")
        addDeck(deckTitle: "Miracle", deckClass: "Rogue")
        addDeck(deckTitle: "Tempo", deckClass: "Mage")
        addDeck(deckTitle: "Zoo", deckClass: "Warlock")
        addDeck(deckTitle: "Golden Monkey", deckClass: "Priest")
    }
    
    func testCancelButton() {
        addDeckButton.tap()
        textField.tap()
        textField.typeText("Pressing cancel")
        app.buttons["Done"].tap()
        druidButton.tap()
        cancelButton.tap()
        XCTAssert(deckScreenTitle.exists)
        XCTAssertFalse(app.tables.staticTexts["Pressing cancel"].exists)
    }
    
    func testDeleteDeck() {
        
        let alertTitle = app.alerts["Delete games?"].staticTexts["Delete games?"]
        let alertText = app.alerts["Delete games?"].staticTexts["Do you want also to delete all the games recorded with this deck ?"]
        let alertCancelButton = app.alerts["Delete games?"].collectionViews.buttons["Cancel"]
        let alertYesButton = app.alerts["Delete games?"].collectionViews.buttons["Cancel"]
        
        Settings().resetAll()
        decksTab.tap()
        
        let deckName = app.tables.staticTexts["Delete Deck"]
        addDeckButton.tap()
        textField.tap()
        textField.typeText("Delete Deck")
        app.buttons["Done"].tap()
        druidButton.tap()
        saveButton.tap()
        XCTAssert(deckScreenTitle.exists)
        XCTAssert(deckName.exists)
        deckName.swipeLeft()
        app.tables.buttons["Delete"].tap()
        
        // Check alert
        XCTAssert(alertTitle.exists)
        XCTAssert(alertText.exists)
        XCTAssert(alertCancelButton.exists)
        XCTAssert(alertYesButton.exists)
        
        alertCancelButton.tap()
        
        // Check deck does not exist anymore
        XCTAssertFalse(deckName.exists)
        
    }
    
    func addDeck(deckTitle: String, deckClass: String) {
        addDeckButton.tap()
        textField.tap()
        textField.typeText(deckTitle)
        app.buttons["Done"].tap()
        let deckButton = deckClass + "Small"
        app.buttons[deckButton].tap()
        saveButton.tap()
    }
    
    func tapDeck(deckTitle: String) {
        XCTAssert(deckScreenTitle.exists)
        let deckCell = XCUIApplication().tables.staticTexts[deckTitle]
        XCTAssert(deckCell.exists)
        deckCell.tap()
    }
    
    func testDeckNameAlreadyExists() {
        Settings().resetAll()
        decksTab.tap()
        
        addDeck(deckTitle: "Midrange", deckClass: "Druid")
        addDeck(deckTitle: "Midrange", deckClass: "Hunter")
        
        XCTAssert(app.alerts["Deck already exists"].staticTexts["Deck already exists"].exists)
        XCTAssert(app.alerts["Deck already exists"].staticTexts["Deck name already exists"].exists)
        XCTAssert(app.alerts["Deck already exists"].collectionViews.buttons["OK"].exists)
        app.alerts["Deck already exists"].collectionViews.buttons["OK"].tap()
    }
    
    func elementsDeckTab() {
        XCTAssert(addDeckButton.exists, "Add New Deck button does not exist")
        XCTAssert(deckScreenTitle.exists, "Deck screen title does not exist")
    }
    
    func elementsNewDeckScreen() {
        
        XCTAssert(cancelButton.exists, "Cancel button does not exist")
        XCTAssert(addNewDeckScreenTitle.exists)
        XCTAssert(saveButton.exists)
        XCTAssert(textField.exists)
        XCTAssert(selectClassLabel.exists)
        XCTAssert(warriorButton.exists)
        XCTAssert(paladinButton.exists)
        XCTAssert(shamanButton.exists)
        XCTAssert(hunterButton.exists)
        XCTAssert(druidButton.exists)
        XCTAssert(rogueButton.exists)
        XCTAssert(mageButton.exists)
        XCTAssert(warlockButton.exists)
        XCTAssert(priestButton.exists)
    }
}
