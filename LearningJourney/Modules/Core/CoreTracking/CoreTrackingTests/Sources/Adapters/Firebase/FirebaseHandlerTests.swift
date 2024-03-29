import XCTest

@testable import CoreTracking

final class FirebaseHandlerTests: XCTestCase {
    
    // MARK: - Unit tests
    
    func test_handler_properlyInitializes() {
        let sut = FirebaseHandler()
        
        XCTAssertEqual(sut.destination, .firebase)
        XCTAssertTrue(sut.logger is FirebaseLogger)
    }
}
