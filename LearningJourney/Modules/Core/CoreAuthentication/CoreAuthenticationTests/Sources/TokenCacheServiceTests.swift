import XCTest
import Security

@testable import CoreAuthentication

final class TokenCacheServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private let keychainMock = KeychainManagerMock()
    private lazy var sut = TokenCacheService(keychainManager: keychainMock)
    
    // MARK: - Unit tests
    
    func test_token_whenCacheIsEmpty_itShouldReturnNil() {
        // Given / When
        let token = sut.token
        
        // Then
        XCTAssertNil(token)
        XCTAssertEqual(keychainMock.copyCallCount, 1)
    }
    
    func test_token_whenCached_itShouldReturnData() throws {
        // Given
        keychainMock.dataToCopy = try .tokenFixture()
        
        // When
        let token = sut.token
        
        // Then
        XCTAssertNotNil(token)
        XCTAssertEqual(keychainMock.copyCallCount, 1)
    }
    
    func test_cache_itShouldDeleteCurrentItem_andAddNewItem() throws {
        // Given
        let dummyData: Data = try .tokenFixture()
        
        // When
        sut.cache(token: dummyData)
        
        // Then
        XCTAssertEqual(keychainMock.addCallCount, 1)
        XCTAssertEqual(keychainMock.copyCallCount, 0)
        XCTAssertEqual(keychainMock.deleteCallCount, 1)
        
    }
    
    func test_clear_itShouldDeleteCurrentItem() {
        // Given / When
        sut.clear()
        
        // Then
        XCTAssertEqual(keychainMock.deleteCallCount, 1)
        XCTAssertEqual(keychainMock.addCallCount, 0)
        XCTAssertEqual(keychainMock.copyCallCount, 0)
    }
}

final class KeychainManagerMock: KeychainManaging {
    
    // MARK: - Properties

    private(set) var addCallCount = 0
    private(set) var copyCallCount = 0
    private(set) var deleteCallCount = 0
    
    // MARK: - Keychain managing
    
    var add: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { _add }
    var copy: (CFDictionary, UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus { _copy }
    var delete: (CFDictionary) -> OSStatus { _delete }
    
    // MARK: - Stubs
    
    var dataToCopy: Data?
    
    // MARK: - Keychain managing
    
    private func _add(_ dict: CFDictionary, res: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        addCallCount += 1
        return noErr
    }
    
    private func _copy(_ dict: CFDictionary, res: UnsafeMutablePointer<CFTypeRef?>?) -> OSStatus {
        res?.pointee = dataToCopy as CFTypeRef?
        copyCallCount += 1
        return noErr
    }
    
    private func _delete(_ dict: CFDictionary) -> OSStatus {
        deleteCallCount += 1
        return noErr
    }
}
