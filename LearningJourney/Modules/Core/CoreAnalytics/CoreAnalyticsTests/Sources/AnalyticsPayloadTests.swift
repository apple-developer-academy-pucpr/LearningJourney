import XCTest

@testable import CoreAnalytics

final class AnalyticsPayloadTests: XCTestCase {
    
    // MARK: - Unit tests
    
    func test_parameters_whenPropertiesAreNil_itShouldReturnNil() {
        // Given
        let sut = AnalyticsPayloadSyub(properties: nil)
        
        // When / Then
        XCTAssertNil(sut.parameters)
    }
    
    func test_parameters_whenPropertiesExist_itShouldProperlyParse() {
        // Given
        let sut = AnalyticsPayloadSyub(properties: [
            AnalyticsProperty(
                name: "dummyProp1",
                value: "dummyValue"),
            AnalyticsProperty(
                name: "dummyProp2",
                value: 2),
        ])
        
        let expectedParameters: [String : AnyHashable] = [
            "dummyProp1": "dummyValue",
            "dummyProp2": 2
        ]
        
        // When
        
        let parameters = sut.parameters
        
        // Then
        XCTAssertEqual(parameters, expectedParameters)
    }
    
}

struct AnalyticsPayloadSyub: AnalyticsPayload {
    var name: String { "dummy" }
    let properties: [AnalyticsProperty]?
}
