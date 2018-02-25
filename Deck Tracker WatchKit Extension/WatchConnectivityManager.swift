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
        
        session.activate()
        applicationContext = session.applicationContext
        return true
    }
    
    func updateApplicationContext(_ context: [String: Any]) {
        guard session.activationState == .activated else {
            return
        }
        do {
            try session.updateApplicationContext(context)
        }
        catch {
            print("updateContextError: \(String(describing: error))")
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
        
        #if os(iOS)
            applicationContext = session.receivedApplicationContext
        #else
            applicationContext = session.applicationContext
        #endif
        
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
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
    }
}

