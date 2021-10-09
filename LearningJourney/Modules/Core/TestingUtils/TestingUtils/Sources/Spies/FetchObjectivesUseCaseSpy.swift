//
//  FetchObjectivesUseCaseSpy.swift
//  JLibraryTests
//
//  Created by Maria Fernanda Azolin on 08/10/21.
//

import Foundation
@testable import JLibrary

public final class FetchObjectivesUseCaseSpy: FetchObjectivesUseCaseProtocol {
    
    public init() {}
    
    public var objectiveToUse: Result<[LearningObjective], LibraryRepositoryError> = .failure(.unknown)
    public var shouldHandle = true
    public private(set) var learningGoalPassed: LearningGoal?
    public private(set) var executeCallCount = 0
    
    public func execute(using learningGoal: LearningGoal, then handle: @escaping Completion) {
        executeCallCount += 1
        guard shouldHandle else { return }
        
        learningGoalPassed = learningGoal
        handle(objectiveToUse)
    }
}
