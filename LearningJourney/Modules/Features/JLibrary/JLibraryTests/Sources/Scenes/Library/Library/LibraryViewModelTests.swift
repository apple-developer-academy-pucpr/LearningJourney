import XCTest
@testable import JLibrary

final class LibraryViewModelTests: XCTestCase {

    // MARK: - Properties

    private let fetchStrandsUseCase = FetchStrandsUseCaseMock()
    private let signoutUseCase = SignoutUseCaseStub()

    private lazy var sut = LibraryViewModel(
        useCases: .init(
            fetchStrandsUseCase: fetchStrandsUseCase,
            signoutUseCase: signoutUseCase
        ))

    // MARK: - Unit tests

    func test_handleOnAppear_whenResultSucceeds_strandsAreLoaded() {
        // Given
        fetchStrandsUseCase.resultToUse = .success([])

        // When
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(sut.strands, .result([]))
    }
}

final class FetchStrandsUseCaseMock: FetchStrandsUseCaseProtocol {
    var resultToUse: Result<[LearningStrand], LibraryRepositoryError> = .failure(.unknown)

    func execute(then handle: @escaping Completion) {
        handle(resultToUse)
    }
}

final class SignoutUseCaseStub: SignoutUseCaseProtocol {
    func execute() {}
}
