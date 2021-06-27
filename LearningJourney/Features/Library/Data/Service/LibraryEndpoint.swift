import Foundation

enum LibraryEndpoint {
    case fetchStrand
    case fetchObjectives(UUID)
}

extension LibraryEndpoint: ApiEndpoint {
    var path: String {
        switch self {
        case .fetchStrand:
            return "strands/"
        case let .fetchObjectives(goalId):
            return "goal/\(goalId.uuidString)"
        }
    }
}
