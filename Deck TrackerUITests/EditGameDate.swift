//
//  EditGameDate.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 06/05/16.
//  Copyright © 2016 Andrei Joghiu. All rights reserved.
//

import XCTest

class EditGameDate: Utils {
        
    let editedGame = XCUIApplication().cells.element(boundBy: 0)
    let pickDateCell = XCUIApplication().cells.element(boundBy: 0)
    var year =  -1
    var month = -1
    var day = -1
    var longMonth = ""
    
    
    let backButton = XCUIApplication().navigationBars["Select Date"].buttons["Edit Game"]
    let selectDateTitleScreen = XCUIApplication().navigationBars["Select Date"].staticTexts["Select Date"]
    
    override func setUp() {
        super.setUp()
        app.launch()
        sleep(timer: 1.0)
        resetAll()
        AddNewGame().addNewGame(date: "", deckName: "Edit Date", deckClass: "Priest", opponent: "Warlock", coin: false, win: true, tag: "")
        editedGame.tap()
        pickDateCell.tap()
        getElementsFromDate()
    }
    
    func testDateWheel() {
        XCTAssert(backButton.exists)
        XCTAssert(selectDateTitleScreen.exists)
        XCTAssert(app.datePickers.pickerWheels[String(day)].exists)
        XCTAssert(app.datePickers.pickerWheels[longMonth].exists)
        XCTAssert(app.datePickers.pickerWheels[String(year)].exists)
        backButton.tap()
        XCTAssert(EditGame().editGameTitle.exists)
    }
    
    func getElementsFromDate() {
        
        let date = Date()
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.day , .month , .year], from: date)
        
        year =  components.year!
        month = components.month!
        day = components.day!
        
        let dateFormatter: DateFormatter = DateFormatter()
        let months = dateFormatter.monthSymbols
        longMonth = months![month-1] // month - from your date components
    }
    
}
