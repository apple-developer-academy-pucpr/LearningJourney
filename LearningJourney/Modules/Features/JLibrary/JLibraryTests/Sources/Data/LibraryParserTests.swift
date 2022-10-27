import XCTest
@testable import JLibrary

final class LibraryParserTests: XCTestCase {
  // MARK: - System under test

  private let sut = LibraryParser()

  // MARK: - Tests

  func testParseDecodableDataShouldSucceed() throws {
        // Given
        let json = "{}"
        let encodedData = try XCTUnwrap(json.data(using: .utf8))

        // When
        let result: Result<Dictionary<String, String>, ParsingError> = sut.parse(encodedData)

        // Then
        XCTAssertNoThrow(try result.get())
    }

    func testParseUndecodableDataShouldFail() throws {
        // Given
        let invalidJson = "{" // any invalid JSON is undecodable
        let encodedData = try XCTUnwrap(invalidJson.data(using: .utf8))

        // When
        let result: Result<String, ParsingError> = sut.parse(encodedData)

        // Then
        XCTAssertThrowsError(try result.get(), "Expected decoding to fail, but got \(result)")
    }
}
