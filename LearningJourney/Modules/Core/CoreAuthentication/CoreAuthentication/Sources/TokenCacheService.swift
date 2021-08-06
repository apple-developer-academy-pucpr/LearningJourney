import Security
import Foundation

protocol TokenCacheServicing {
    var token: Data? { get }
    func cache(token: Data) -> Bool
    func clear()
}

final class TokenCacheService: TokenCacheServicing {
    
    // MARK: - Inner types
    
    private enum Constants {
        enum KeychainValues {
            static let attrAccount: String = kSecAttrAccount as String
            static let `class`: String = kSecClass as String
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
    private let keychainManager: KeychainManaging
    private let lock = NSLock()
    private var lastQueryParameters: [String: Any]?
    private(set) var lastResultCode: OSStatus = noErr
    
    // MARK: - Initialization
    
    init(
        keychainManager: KeychainManaging = KeychainManager()
    ) {
        self.keychainManager = keychainManager
    }

    // MARK: - Caching
    
    var token: Data? {
        lock.lock()
        defer { lock.unlock() }
        return fetchItem(for: Constants.Keys.token)
    }
    
    @discardableResult
    func cache(token: Data) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return createItem(token, for: Constants.Keys.token)
    }
    
    func clear() {
        lock.lock()
        defer { lock.unlock() }
        
        let query = [Constants.KeychainValues.class : kSecClassGenericPassword]
        let _ = keychainManager.delete(query as CFDictionary)
        
        // TODO this should be handled by an error!
//        guard result == noErr || result == -25300 else { fatalError("Failed to clear keychain! \(result) \(String(describing: SecCopyErrorMessageString(result, nil)))") }
    }
    
    // MARK: - Helpers
    
    private func deleteItem(for key: String) -> Bool {
        let query: [String: Any] = [
            Constants.KeychainValues.class       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : key
        ]
        
        lastQueryParameters = query
        lastResultCode = keychainManager.delete(query as CFDictionary)
        
        return lastResultCode == noErr || lastResultCode == errSecItemNotFound
    }
    
    private func createItem(_ token: Data, for key: String) -> Bool {
        guard deleteItem(for: key) else {
            return false
        } // TODO consider handling this with errors
        
        let query: [String : Any] = [
            Constants.KeychainValues.class       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : key,
            Constants.KeychainValues.accessible  : kSecAttrAccessibleWhenUnlocked,
            Constants.KeychainValues.valueData   : token as Any
        ]
         
        lastQueryParameters = query
        
        lastResultCode = keychainManager.add(query as CFDictionary, nil)
        
        return lastResultCode == noErr
    }
    
    private func fetchItem(for key: String) -> Data? {
        var result: AnyObject?
        let query: [String: Any] = [ // TODO consider creating a builder
            Constants.KeychainValues.class       : kSecClassGenericPassword,
            Constants.KeychainValues.attrAccount : Constants.Keys.token,
            Constants.KeychainValues.matchLimit  : kSecMatchLimitOne,
            Constants.KeychainValues.returnData  : kCFBooleanTrue as Any
        ]
        
        lastQueryParameters = query
        lastResultCode = keychainManager.add(query as CFDictionary, nil)
        lastResultCode = withUnsafeMutablePointer(to: &result) {
            keychainManager.copy(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard lastResultCode == noErr else { return nil }
        return result as? Data
    }
}
