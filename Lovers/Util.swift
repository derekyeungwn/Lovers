//
//  Util.swift
//  Lovers
//
//  Created by Derek Yeung on 19/2/2022.
//

import Foundation
import SwiftUI

final class KeychainService {
    
    static let standard = KeychainService()
    private init() {}
    
    func save(data: String, service: String, account: String) {
        
        let query = [
            kSecValueData: Data(data.utf8),
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
        if status == errSecDuplicateItem {
          
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: Data(data.utf8)] as CFDictionary
                
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service: String, account: String) -> String? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
            
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        guard let data = result as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)!
    }
    
    func delete(service: String, account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
}
