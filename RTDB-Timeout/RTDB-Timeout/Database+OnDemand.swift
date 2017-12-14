//
//  OnDemandDatabase.swift
//  RTDB-Timeout
//
//  Created by Diego Trevisan Lara on 14/12/2017.
//  Copyright © 2017 Diego Trevisan Lara. All rights reserved.
//

import Firebase

extension Database {
    
    static var defaultTimeout: TimeInterval!
    private static var saveConnections: Bool!
    private static var connectionsCount = 0
    
    func configure(saveConnections: Bool = true, timeout: TimeInterval = 10) {
        Database.saveConnections = saveConnections
        Database.defaultTimeout = timeout
        disconnect()
    }
    
    func connect() {
        guard Database.saveConnections else { return }
        Database.connectionsCount += 1
        goOnline()
    }
    
    func disconnect() {
        guard Database.saveConnections else { return }
        Database.connectionsCount = max(0, Database.connectionsCount-1)
        
        if Database.connectionsCount == 0 {
            goOffline()
        }
    }
    
}
