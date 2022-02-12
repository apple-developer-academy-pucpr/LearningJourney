import SwiftUI
import UI

protocol LibraryViewModelProtocol: ObservableObject {
    var strands: LibraryViewModelState<[LearningStrand]> { get }
    var searchQuery: String { get set }
    var isList: Bool { get }
    func handleOnAppear()
    func handleUserDidChange()
    func handleSignout()
    func togglePresentationMode()
}

enum LibraryViewModelState<T: Equatable>: Equatable {
    case loading
    case empty
    case error(ViewError)
    case result(T)
}

extension LibraryViewModelState: Identifiable where T == LearningObjective {
    var id: UUID { UUID() }
}

final class LibraryViewModel: LibraryViewModelProtocol {
    
    // MARK: - Inner types
    
    struct UseCases {
        let fetchStrandsUseCase: FetchStrandsUseCaseProtocol
        let signoutUseCase: SignoutUseCaseProtocol
    }
    
    // MARK: - ViewModel properties
    
    @Published private(set)
    var strands: LibraryViewModelState<[LearningStrand]> = .empty
    
    @Published
    var searchQuery: String = ""
    
    @Published
    var isList: Bool = true
    
    // MARK: - Dependencies
    
    private let useCases: UseCases
    
    // MARK: - Initialization
    
    init(useCases: UseCases) {
        self.useCases = useCases
    }
    
    // MARK: - View Events
    
    func handleUserDidChange() {
        fetchStrands()
    }
    
    func handleOnAppear() {
        fetchStrands()
    }
    
    func handleSignout() {
        useCases.signoutUseCase.execute()
    }
    
    func togglePresentationMode() {
        isList.toggle()
    }
    
    // MARK: - Helper functions
    
    private func fetchStrands() {
        if strands == .loading { return }
        strands = .loading
        useCases.fetchStrandsUseCase.execute { [weak self] in
            switch $0 {
            case let .success(strands):
                self?.strands = .result(strands)
            case let .failure(error):
                self?.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: LibraryRepositoryError) {
        switch error {
        case .unauthorized:
            strands = .error(.notAuthenticated)
        case .api, .parsing, .unknown:
            strands = .error(.unknown(fetchStrands))
        }
    }
}
