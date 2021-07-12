import XCTest

import CoreAuthentication

@testable import JAuthentication

final class AuthenticationParserTests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = AuthenticationParser()
    
    // MARK: - Unit tests
    
    func test_parse_whenEncodingSucceeds_itShouldReturnParsedModel() throws {
        // Given
        let expectedString = "dummy"
        let expectedToken = try JSONEncoder().encode(TokenPayload.fixture())
        
        // When
        let result: Result<TokenPayload, ParsingError> = sut.parse(expectedToken)
        
        // Then
        guard case let .success(payload) = result
        else {
            XCTFail("Expected parsing to succeed, but got failure instead")
            return
        }
    
        XCTAssertEqual(payload.token, expectedString)
    }
    
    func test_parse_whenEncodingFails_itShouldReturnInvalidData() throws {
        // Given
        let expectedToken = try JSONEncoder().encode(TokenPayload.fixture())
        
        // When
        let result: Result<Int, ParsingError> = sut.parse(expectedToken)
        
        // Then
        guard case let .failure(error) = result,
              case .invalidData = error
        else {
            XCTFail("Expected parsing to succeed, but got failure instead")
            return
        }
    }
}
