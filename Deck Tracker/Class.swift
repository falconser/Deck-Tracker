//
//  Class.swift
//  Deck Tracker
//
//  Created by Sergey Ischuk on 2/18/18.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import Foundation
import UIKit

enum Class: String {
    case Unknown
    case Warrior
    case Paladin
    case Shaman
    case Druid
    case Rogue
    case Mage
    case Warlock
    case Priest
    case Hunter
    case DemonHunter

    init(_ str: String) {
        if str == "Warrior" {
            self = .Warrior
        } else if str == "Paladin" {
            self = .Paladin
        } else if str == "Shaman" {
            self = .Shaman
        } else if str == "Druid" {
            self = .Druid
        } else if str == "Rogue" {
            self = .Rogue
        } else if str == "Mage" {
            self = .Mage
        } else if str == "Warlock" {
            self = .Warlock
        } else if str == "Priest" {
            self = .Priest
        } else if str == "Hunter" {
            self = .Hunter
        } else if str == "DemonHunter" {
            self = .DemonHunter
        } else {
            self = .Unknown
        }
    }
    func smallIconName() -> String {
        switch self {
        case .Warrior:
            return "WarriorSmall"
        case .Paladin:
            return "PaladinSmall"
        case .Shaman:
            return "ShamanSmall"
        case .Druid:
            return "DruidSmall"
        case .Rogue:
            return "RogueSmall"
        case .Mage:
            return "MageSmall"
        case .Warlock:
            return "WarlockSmall"
        case .Priest:
            return "PriestSmall"
        case .Hunter:
            return "HunterSmall"
        case .DemonHunter:
            return "DemonHunterSmall"
        default:
            return ""
        }
    }
    
    func color() -> UIColor? {
        switch self {
        case .Warrior:
            return .init(rgbValue: 0xCC0000)
        case .Paladin:
            return .init(rgbValue: 0xCCC333)
        case .Shaman:
            return .init(rgbValue: 0x3366CC)
        case .Hunter:
            return .init(rgbValue: 0x339933)
        case .Druid:
            return .init(rgbValue: 0x990000)
        case .Rogue:
            return .init(rgbValue: 0x666666)
        case .Warlock:
            return .init(rgbValue: 0x8787ED)
        case .Mage:
            return .init(rgbValue: 0x009999)
        case .Priest:
            return .init(rgbValue: 0x999999)
        case .DemonHunter:
            return .init(rgbValue: 0xA330C9)
        default:
            return nil
        }
    }
    func smallIcon() -> UIImage? {
        return UIImage(named: smallIconName())
    }

}

