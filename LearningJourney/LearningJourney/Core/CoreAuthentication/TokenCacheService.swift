import Security
import Foundation

protocol TokenCacheServicing {
    var token: Data? { get }
    var lastResultCode: OSStatus { get }
    func cache(token: Data) -> Bool
}

// TODO figure out how to mock Keychain functions
// TODO Consider creating a wrapper for Keychain
final class TokenCacheService: TokenCacheServicing {
    
    // MARK: - Inner types
    
    private enum Constants {
        enum KeychainValues {
            static let attrAccount: String = kSecAttrAccount as String
            static let klass: String = kSecClass as String
            static let matchLimit: String = kSecMatchLimit as String
            static let returnData: String = kSecReturnData as String
            static let valueData: String = kSecValueData as String
            static let accessible: String = kSecAttrAccessible as String
        }
        
        private static let keyPrefix = "learningjourney."
        enum Keys {
            static let token = "\(Constants.keyPrefix)apiToken"
        }
    }
    
    // MARK: - Properties
    
    private let lock = NSLock()
    private var lastQueryParameters: [String: Any]?
    private(set) var lastResultCode: OSStatus = noErr
    
    // MARK: - Caching
    
    var token: Data? {
        lock.lock()
        defer { lock.unlock() }
        return fetchItem(for: Constants.Keys.token)
    }
    
    func cache(token: Data) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return createItem(token, for: Constants.Keys.token)
    }
    
    // MARK: - Helpers
    
    private func deleteItem(for key: String) -> Bool {
        let query: [String: Any] = [
            Constants.KeychainValues.klass       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : key
        ]
        
        lastQueryParameters = query
        lastResultCode = SecItemDelete(query as CFDictionary)
        
        return lastResultCode == noErr || lastResultCode == errSecItemNotFound
    }
    
    private func createItem(_ token: Data, for key: String) -> Bool {
        guard deleteItem(for: key) else {
            return false
        } // TODO consider handling this with errors
        
        let query: [String : Any] = [
            Constants.KeychainValues.klass       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : key,
            Constants.KeychainValues.accessible  : kSecAttrAccessibleWhenUnlocked,
            Constants.KeychainValues.valueData   : token as Any
        ]
         
        lastQueryParameters = query
        
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
        
        return lastResultCode == noErr
    }
    
    private func fetchItem(for key: String) -> Data? {
        var result: AnyObject?
        let query: [String: Any] = [ // TODO consider creating a builder
            Constants.KeychainValues.klass       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : Constants.Keys.token,
            Constants.KeychainValues.matchLimit  : kSecMatchLimitOne,
            Constants.KeychainValues.returnData  : kCFBooleanTrue as Any
        ]
        
        lastQueryParameters = query
        lastResultCode = SecItemAdd(query as CFDictionary, nil)
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard lastResultCode == noErr else { return nil }
        return result as? Data
    }
}

#if DEBUG

extension TokenCacheService {
    func clear() {
        print("Cleared keychain!")
        lock.lock()
        defer { lock.unlock() }
        
        let query = [kSecClass : kSecClassGenericPassword]
        let result = SecItemDelete(query as CFDictionary)
        
        guard result == noErr || result == -25300 else { fatalError("Failed to clear keychain! \(result) \(SecCopyErrorMessageString(result, nil))")}
    }
}

#endif
