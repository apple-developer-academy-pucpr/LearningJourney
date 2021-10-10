import XCTest
@testable import JLibrary
import CoreAdapters
import CoreAuthentication

final class SignoutUseCaseTests: XCTestCase {
    // MARK: - Properties

    private let tokenCacheSpy = TokenCacheSpy()
    private let notificationCenterSpy = NotificationCenterSpy()
    private lazy var sut = SignoutUseCase(cache: tokenCacheSpy, notificationCenter: notificationCenterSpy)

    // MARK: - Unit tests

    func test_execute_itShouldNotifyAuthChange() {
        // Given

        // When

        sut.execute()

        // Then

        XCTAssertEqual(notificationCenterSpy.postedNotificationsCount, 1)
    }

    func test_execute_itShouldClearCache() {
        // Given

        // When

        sut.execute()

        // Then

        XCTAssertEqual(tokenCacheSpy.cacheClearedCount, 1)
    }
}

// MARK: - Testing doubles

final class NotificationCenterSpy: NotificationCenterProtocol {
    func addObserver(_ observer: Any, selector: Selector, name: NotificationName) {
        fatalError("not implemented")
    }

    private(set) var postedNotificationsCount = 0
    func post(name: NotificationName) {
        postedNotificationsCount += 1
    }

    func post(name: NotificationName, payload: Payload?) {
        fatalError("not implemented")
    }

    func removeObserver(_ observer: Any) {
        fatalError("not implemented")
    }

    func publisher(for name: NotificationName) -> NotificationCenterProtocol.Publisher {
        fatalError("not implemented")
    }
}

final class TokenCacheSpy: TokenCleaning {
    private(set) var cacheClearedCount = 0
    func clear() {
        cacheClearedCount += 1
    }
}
