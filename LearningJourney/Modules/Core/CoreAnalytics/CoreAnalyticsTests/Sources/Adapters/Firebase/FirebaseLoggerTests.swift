import XCTest

@testable import CoreAnalytics

final class FirebaseLoggerTests: XCTestCase {
    // MARK: - Unit tests
    
    func test_log_itShouldCallFirebaseAnalytics() {
        // Given
        let eventStub = AnalyticsPayloadSyub(properties: nil)
        let sut = FirebaseLogger(logger: FirebaseLoggingSpy.self)
        
        // When
        sut.log(event: eventStub)
        
        // Then
        XCTAssertEqual(FirebaseLoggingSpy.logEventCallCount, 1)
    }
}

final class FirebaseLoggingSpy: FirebaseLogging {
    private(set) static var logEventCallCount = 0
    static func logEvent(_ name: String, parameters: [String : Any]?) {
        logEventCallCount += 1
    }
}
