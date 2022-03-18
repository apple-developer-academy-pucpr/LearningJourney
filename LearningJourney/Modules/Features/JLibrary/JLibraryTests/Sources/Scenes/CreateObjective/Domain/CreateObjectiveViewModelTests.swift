import XCTest

@testable import JLibrary

final class CreateObjectiveViewModelTests: XCTestCase {
    
    private let fetchNewObjectiveMetadataUseCaseStub = FetchNewObjectiveMetadataUseCaseStub()
    private let createNewObjectiveUseCaseStub = CreateNewObjectiveUseCaseStub()
    private lazy var sut = CreateObjectiveViewModel(
        useCases: .init(
            fetchNewObjectiveMetadataUseCase: fetchNewObjectiveMetadataUseCaseStub,
            createObjectiveUseCase: createNewObjectiveUseCaseStub),
        goal: .fixture(),
        isPresented: .constant(true))
    
    func test_handleAppear_whenLoading_itShouldReturn() {
        
    }
}

final class FetchNewObjectiveMetadataUseCaseStub: FetchNewObjectiveMetadataUseCaseProtocol {
    var resultToUse: Result<NewObjectiveMetadata, LibraryRepositoryError> = .failure(.unknown)
    func execute(goalId: String, then handle: @escaping Completion) {
        handle(resultToUse)
    }
}

final class CreateNewObjectiveUseCaseStub: CreateNewObjectiveUseCaseProtocol {
    var resultToUse: Result<LearningObjective, LibraryRepositoryError> = .failure(.unknown)
    func execute(goalId: String, description: String, completion: @escaping Completion) {
        completion(resultToUse)
    }
}


