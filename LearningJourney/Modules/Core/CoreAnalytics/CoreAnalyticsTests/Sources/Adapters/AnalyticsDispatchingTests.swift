import XCTest

@testable import CoreAnalytics

final class AnalyticsDispatchingTests: XCTestCase {
    
    // MARK: - Unit tests
    func test_destinations_properlyContainsDefault() {
        // Given
        let sut = AnalyticsDispatchingDummy()
        
        // When / Then
        XCTAssertEqual(sut.destinations, [.firebase])
    }
}

final class AnalyticsDispatchingDummy: AnalyticsDispatching {
    
}
