//
//  UserDefaultsManager.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 25/8/25.
//

import UIKit

enum UserKey: String {
    case userId = "userId"
    case name = "name"
}

class UserDefaultsManager: NSObject {
    static let shared = UserDefaultsManager()
    private override init() {
    }
    
    private func set(val: Any, key: UserKey) {
        UserDefaults.standard.set(val, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    private func get(key: UserKey) -> Any? {
        if let value = UserDefaults.standard.value(forKey: key.rawValue) {
            return value
        } else {
            return nil
        }
    }
    
    var userId: String? {
        get {
            return self.get(key: .userId) as? String
        }
        set {
            guard let newValue = newValue else { return }
            self.set(val: newValue, key: .userId)
        }
    }
    
    var name: String? {
        get {
            return self.get(key: .name) as? String
        }
        set {
            guard let newValue = newValue else { return }
            self.set(val: newValue, key: .name)
        }
    }
}
