import CoreNetworking

protocol CreateObjectiveViewModelProtocol {
    func didTapOnCreate()
}

final class CreateObjectiveViewModel: CreateObjectiveViewModelProtocol {
    var service: LibraryRemoteServiceProtocol?
    
    func didTapOnCreate() {
        service?.createObjective(using: .init(
            description: "dummy",
            goalId: "62178ff2b7db4fec365e6a60"))
    }
}
