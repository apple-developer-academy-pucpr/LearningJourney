import XCTest
@testable import JLibrary

final class LibraryParserTests: XCTestCase {
    // MARK: - System under test

    private let sut = LibraryParser()

    // MARK: - Tests

    func testParseDecodableDataShouldSucceed() {
        // Given
        let decodableData = DecodableData()
        let encodedData = try! JSONEncoder().encode(decodableData)

        // When
        let parseResult: Result<DecodableData, ParsingError> = sut.parse(encodedData)

        // Then
        switch parseResult {
            case .success(let data):
                XCTAssertEqual(data, decodableData)
            case .failure(let error):
                XCTFail("Expected decoded data but got \(error)")
        }
    }

    func testParseUndecodableDataShouldFail() {
        // Given
        let undecodableData = UndecodableData()
        let encodedData = try! JSONEncoder().encode(undecodableData)

        // When
        let parseResult: Result<DecodableData, ParsingError> = sut.parse(encodedData)

        // Then
        switch parseResult {
            case .success(let data):
                XCTFail("Input data shouldn't be decodable but got \(data)")
            case .failure:
                break
        }
    }
}

private struct DecodableData: Encodable, Decodable, Equatable {
    var areWeLucky: Bool = .random()
}

private struct UndecodableData: Encodable { }
