//
//  DatabaseReference+Timeout.swift
//  RTDB-Timeout
//
//  Created by Diego Trevisan Lara on 14/12/2017.
//  Copyright © 2017 Diego Trevisan Lara. All rights reserved.
//

import Firebase

fileprivate var timerKey: UInt8 = 0
fileprivate var cancelKey: UInt8 = 1
extension DatabaseReference {
    
    // Workaround for storing properties in extensions
    private var timer: Timer? {
        get {
            guard let value = objc_getAssociatedObject(self, &timerKey) as? Timer else { return nil }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &timerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var withCancel: ((Error) -> Void)? {
        get {
            guard let value = objc_getAssociatedObject(self, &cancelKey) as? ((Error) -> Void) else { return nil }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &cancelKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension DatabaseReference {
    
    func observeSingleEvent(of: DataEventType, with: @escaping (DataSnapshot) -> Void, withCancel: ((Error) -> Void)?, timeout: TimeInterval = Database.defaultTimeout) {
        
        database.connect()
        
        self.withCancel = withCancel
        self.timer = Timer.scheduledTimer(timeInterval: timeout, target: self, selector: #selector(timeoutFail), userInfo: nil, repeats: false)
        
        observeSingleEvent(of: of, with: { snapshot in
            self.finish({ with(snapshot) })
            
        }) { error in
            self.finish({ withCancel?(error) })
        }
        
    }
    
    private func finish(_ completion: () -> Void) {
        timer?.invalidate()
        database.disconnect()
        completion()
        
        self.withCancel = nil
        self.timer = nil
    }
    
    @objc private func timeoutFail() {
        finish({ withCancel?(NSError(domain: String(describing: self), code: NSURLErrorTimedOut, userInfo: ["description": description()])) })
    }
    
}
