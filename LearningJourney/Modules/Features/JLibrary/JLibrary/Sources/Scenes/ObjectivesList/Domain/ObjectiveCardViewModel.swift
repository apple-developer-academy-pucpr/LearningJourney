//
//  ObjectiveCardViewModel.swift
//  JLibrary
//
//  Created by Bruno Pastre on 16/02/22.
//

import Foundation

protocol ObjectiveCardViewModelProtocol: ObservableObject {
    var state: LibraryViewModelState<LearningObjective> { get }
    func handleLearnStatusToggled()
    func handleWantToLearnToggled()
}

final class ObjectiveCardViewModel: ObjectiveCardViewModelProtocol {
    
    struct UseCases {
        let toggleLearnUseCase: ToggleLearnUseCaseProtocol
        let toggleEagerToLearnUseCase: ToggleEagerToLearnUseCaseProtocol
    }
    
    @Published
    private(set) var state: LibraryViewModelState<LearningObjective>
    
    private let useCases: UseCases
    
    init(useCases: UseCases, objective: LearningObjective) {
        self.useCases = useCases
        state = .result(objective)
    }
    
    func handleLearnStatusToggled() {
        guard case let .result(objective) = state
        else { return }
        state = .loading
        useCases.toggleLearnUseCase.execute(objective: objective) { [weak self] in
            switch $0 {
            case let .success(objective):
                self?.state = .result(objective)
            case .failure:
                self?.state = .result(objective)
            }
        }
    }
    
    
    func handleWantToLearnToggled() {
        guard case let .result(objective) = state
        else { return }
        
        state = .loading
        
        useCases.toggleEagerToLearnUseCase.execute(objective: objective) { [weak self] in
            switch $0 {
            case let .success(objective):
                self?.state = .result(objective)
            case .failure:
                self?.state = .result(objective)
            }
        }
    }
}
