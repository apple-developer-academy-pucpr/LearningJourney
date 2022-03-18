import CoreNetworking
import Combine
import SwiftUI

enum CreateButtonState {
    case disabled, loading, enabled
}

protocol CreateObjectiveViewModelProtocol: ObservableObject {
    var state: LibraryViewModelState<NewObjectiveMetadata> { get }
    var createButtonState: CreateButtonState { get }
    var currentDescription: String { get set }
    func handleAppear()
    func descriptionDidCommit()
    
    func didTapOnCreate()
    func didTapOnCancel()
}

final class CreateObjectiveViewModel: CreateObjectiveViewModelProtocol {

    struct UseCases {
        let fetchNewObjectiveMetadataUseCase: FetchNewObjectiveMetadataUseCaseProtocol
        let createObjectiveUseCase: CreateNewObjectiveUseCaseProtocol
    }
    
    @Published
    private(set) var state: LibraryViewModelState<NewObjectiveMetadata> = .empty
    
    @Published
    private(set) var createButtonState: CreateButtonState = .disabled
    
    @Published
    var currentDescription: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.descriptionDidChange()
            }
        }
    }

    private let useCases: UseCases
    private let goal: LearningGoal
    private let maxDescriptionCount = 280
    
    private var isPresented: Binding<Bool>
    
    init(useCases: UseCases,
         goal: LearningGoal,
         isPresented: Binding<Bool>
    ) {
        self.useCases = useCases
        self.goal = goal
        self.isPresented = isPresented
    }
    
    func handleAppear() {
        fetchMetadata()
    }

    func descriptionDidCommit() {
        createObjectiveIfPossible()
    }
    
    func didTapOnCreate() {
        createObjectiveIfPossible()
    }
    
    func didTapOnCancel() {
        dismiss()
    }
    
    private func createObjectiveIfPossible() {
        guard createButtonState == .enabled else { return }
        createButtonState = .loading
        useCases.createObjectiveUseCase.execute(goalId: goal.id, description: currentDescription) { [weak self] in
            switch $0 {
            case .success:
                self?.dismiss()
                break
            case let .failure(error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: LibraryRepositoryError) {
        switch error {
        case .unauthorized:
            state = .error(.notAuthenticated)
        case .api, .parsing, .unknown:
            state = .error(.unknown(fetchMetadata))
        }
    }
    
    private func fetchMetadata() {
        if state == .loading { return }
        state = .loading
        useCases.fetchNewObjectiveMetadataUseCase.execute(goalId: goal.id) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case let .success(metadata):
                self.state = .result(metadata)
            case let .failure(error):
                self.handleError(error)
            }
        }
    }
    
    private func descriptionDidChange() {
        createButtonState = currentDescription.count > 0 && currentDescription.count < maxDescriptionCount ? .enabled : .disabled
    }
    
    private func dismiss() {
        isPresented.wrappedValue = false
    }
}
