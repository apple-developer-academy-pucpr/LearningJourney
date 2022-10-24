import XCTest
@testable import JLibrary

final class LibraryParserTests: XCTestCase {
    // MARK: - System under test

    private let sut = LibraryParser()

    // MARK: - Tests

    func testParseDecodableDataShouldSucceed() throws {
        // Given
        let decodable = "aDecodableString"
        let encodedData = try XCTUnwrap(decodable.data(encoding: .utf8))
        let expectedDecodedData: Result<String, Error> = .success(decodable)

        // When
        let actualParsedValue = sut.parse(encodedData)

        // Then
        
        XCTAssertEqual(actualParsedValue, expectedDecodedData)
    }

    func testParseUndecodableDataShouldFail() throws {
        // Given
        let invalidJson = "{" // any invalid JSON is undecodable
        let encodedData = try XCTUnwrap(invalidJson.data(using: .utf8))

        // When
        let actualResult = sut.parse(encodedData)

        // Then
        XCTAssertThrowsError(try actualResult.get(), "TODO Message!")
    }
}

private struct DecodableData: Encodable, Decodable, Equatable {
    var areWeLucky: Bool = .random()
}

private struct UndecodableData: Encodable { }
