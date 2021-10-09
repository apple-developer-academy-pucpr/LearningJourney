//
//  ToggleLearnUseCaseSpy.swift
//  JLibraryTests
//
//  Created by Maria Fernanda Azolin on 08/10/21.
//

import Foundation
@testable import JLibrary

final class ToggleLearnUseCaseSpy: ToggleLearnUseCaseProtocol {
    
    var resultToUse: Result<LearningObjective, LibraryRepositoryError> = .failure(.unknown)
    private(set) var objectivePassed: LearningObjective?
    private(set) var executeCalled = false
    
    func execute(objective: LearningObjective, then handle: @escaping Completion) {
        executeCalled = true
        objectivePassed = objective
        handle(resultToUse)
    }
}
