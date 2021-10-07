import XCTest
@testable import JLibrary

final class LibraryViewModelTests: XCTestCase {

    // MARK: - Properties

    private let fetchStrandsUseCase = FetchStrandsUseCaseMock()
    private let signoutUseCase = SignoutUseCaseMock()

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

    func test_handleOnAppear_whenResultFails_strandsAreSetToError() {
        // Given
        fetchStrandsUseCase.resultToUse = .failure(.unauthorized)

        // When
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(sut.strands, .error(.notAuthenticated))
    }

    func test_handleOnAppear_whenAlreadyLoading_secondCallIgnored() {
        // Given
        fetchStrandsUseCase.shouldHandle = false
        sut.handleOnAppear()

        // When
        fetchStrandsUseCase.shouldHandle = true
        sut.handleOnAppear()

        // Then
        XCTAssertEqual(sut.strands, .loading)
    }

    func test_handleUserDidChange_whenResultSucceeds_strandsChanged() {
        // Given
        fetchStrandsUseCase.resultToUse = .success([])
        sut.handleOnAppear()

        // When
        fetchStrandsUseCase.resultToUse = .success([LearningStrand.fixture()])
        sut.handleUserDidChange()

        // Then
        XCTAssertEqual(sut.strands, .result([LearningStrand.fixture()]))
    }

    func test_handleSignout_signoutUseCaseExecuted() {
        // Given / When
        sut.handleSignout()

        // Then
        XCTAssertTrue(signoutUseCase.executed)
    }
}

final class FetchStrandsUseCaseMock: FetchStrandsUseCaseProtocol {
    var resultToUse: Result<[LearningStrand], LibraryRepositoryError> = .failure(.unknown)

    var shouldHandle = true
    func execute(then handle: @escaping Completion) {
        guard shouldHandle else { return }
        handle(resultToUse)
    }
}

final class SignoutUseCaseMock: SignoutUseCaseProtocol {
    var executed = false
    func execute() {
        executed = true
    }
}
