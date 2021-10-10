@testable import JLibrary

final class ToggleLearnUseCaseSpyStub: ToggleLearnUseCaseProtocol {
    
    var resultToUse: Result<LearningObjective, LibraryRepositoryError> = .failure(.unknown)
    private(set) var objectivePassed: LearningObjective?
    private(set) var executeCalled = false
    
    func execute(objective: LearningObjective, then handle: @escaping Completion) {
        executeCalled = true
        objectivePassed = objective
        handle(resultToUse)
    }
}
