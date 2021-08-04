import Security

protocol KeychainManaging {
    var add: (_ attributes: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { get }
    var copy: (_ query: CFDictionary, _ result: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { get }
    var delete: (_ query: CFDictionary) -> OSStatus { get }
}

final class KeychainManager: KeychainManaging {
    var add: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { SecItemAdd }
    var copy: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { SecItemCopyMatching }
    var delete: (CFDictionary) -> OSStatus { SecItemDelete }
}
