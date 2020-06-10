//
//  UserDefaults.swift
//  FormsUtils
//
//  Created by Konrad on 6/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: UserDefaults
public extension UserDefaults {
    func decodable<T: Decodable>(forKey key: String, of type: T.Type) -> T? {
        guard let data: Data = self.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    func encodable<T: Encodable>(_ object: T?, forKey key: String) {
        guard let object: T = object else {
            self.removeObject(forKey: key)
            return
        }
        let encoded: Data? = try? JSONEncoder().encode(object)
        self.set(encoded, forKey: key)
    }
}
