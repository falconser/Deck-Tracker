//
//  WatchConnectivityManager.swift
//  Deck Tracker WatchKit Extension
//
//  Created by Sergey Ischuk on 2/25/18.
//  Copyright © 2018 Andrei Joghiu. All rights reserved.
//

import Foundation
import WatchConnectivity

@objc protocol WatchConnectivityManagerDelegate {
    @objc optional func connectivityManager(_ manager: WatchConnectivityManager, didUpdateApplicationContext: [String: Any])
    @objc optional func connectivityManager(_ manager: WatchConnectivityManager, didReceiveGame: Game)
    @objc optional func connectivityManagerDidActivate(_ manager: WatchConnectivityManager)
}

class WatchConnectivityManager: NSObject {
    private enum Message {
        case addGame(game: Game)
        
        var messageType: String {
            switch self {
            case .addGame:
              return "addGame"
            }
        }
        
        init?(messageDict dict: [String: Any]) {
            guard let type = dict["messageType"] as? String else {
                return nil
            }
            
            if type == "addGame" {
                guard
                    let gameData = dict["game"] as? Data,
                    let game = KeyedUnarchiverMapper.unarchiveObject(with: gameData) as? Game else
                { return nil }
                
                self = .addGame(game: game)
            }
            else {
                return nil
            }
        }
        
        func dict() -> [String: Any] {
            var result: [String: Any] = ["messageType": messageType]
            switch self {
            case .addGame(let game):
                result["game"] = NSKeyedArchiver.archivedData(withRootObject: game)
                break
            }
            return result
        }
    }
    
    let session = WCSession.default
    var delegate: WatchConnectivityManagerDelegate?

    var applicationContext = [String: Any]() {
        didSet {
            delegate?.connectivityManager?(self, didUpdateApplicationContext: applicationContext)
        }
    }
    
    override init() {
        super.init()
        session.delegate = self
    }
    
    @discardableResult
    func activate() -> Bool {
        guard WCSession.isSupported() else {
            return false
        }
        guard session.activationState != .activated else {
            return true
        }
        
        session.activate()
        applicationContext = session.receivedApplicationContext
        return true
    }
    
    func updateApplicationContext(_ context: [String: Any]) {
        guard session.activationState == .activated else { return }
        #if os(iOS)
        guard session.isWatchAppInstalled else { return }
        #endif
        do {
            try session.updateApplicationContext(context)
        }
        catch {
            print("updateContextError: \(String(describing: error))")
        }
    }
//#if os(watchOS)
    func saveGame(_ game: Game) {
        let message = Message.addGame(game: game)
        if session.isReachable {
            session.sendMessage(message.dict(), replyHandler: nil, errorHandler: { error in
                print("sendMessage failed with error: \(error)")
            })
        }
        else {
            session.transferUserInfo(message.dict())
        }
    }
    
    private func processMessage(_ message: Message?) {
        guard let message = message else { return }
        switch message {
        case .addGame(let game):
            self.delegate?.connectivityManager?(self, didReceiveGame: game)
            break
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?)
    {
        guard activationState == .activated else {
            return
        }
        
        
        applicationContext =
            session.applicationContext.isEmpty
            ? session.receivedApplicationContext
            : session.applicationContext
        
        delegate?.connectivityManagerDidActivate?(self)
    }
    
#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {

    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    
    }
#endif
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        self.applicationContext = applicationContext
    }
    
    func session(_ session: WCSession, didReceiveMessage messageDict: [String : Any]) {
        processMessage(Message(messageDict: messageDict))
    }
    
    func session(_ session: WCSession, didReceiveMessage messageDict: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        processMessage(Message(messageDict: messageDict))
    }
    
    func session(_ session: WCSession, didReceiveUserInfo messageDict: [String : Any] = [:]) {
        processMessage(Message(messageDict: messageDict))
    }
}

