//
//  KeychainService.swift
//  CrypyoTrack
//
//  Created by Кирилл Зубков on 11.03.2025.
//


import Security
import Foundation

class KeychainService {
    
    // MARK: - Properties
    
    static let shared = KeychainService()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Interface
    
    func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        return SecItemAdd(query, nil) == errSecSuccess
    }
    
    func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        return status == errSecSuccess ? (dataTypeRef as? Data) : nil
    }
    
    @discardableResult
    func delete(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        return SecItemDelete(query) == errSecSuccess
    }
    
}
