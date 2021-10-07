import SwiftUI

public enum ViewError: Equatable {
    case notAuthenticated
    case unknown (UnknownErrorCallback)
    
    public static func == (lhs: ViewError, rhs: ViewError) -> Bool {
        switch (lhs, rhs) {
        case (.notAuthenticated, .notAuthenticated),
             (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}

public extension ViewError {
    var view: AnyView {
        switch self {
        case .notAuthenticated:
            return AnyView(Text("salve"))
        case let .unknown (callback):
            return AnyView(UnknownErrorView(action: callback))
        }
    }
}

public extension View {
    func errorView(for error: ViewError) -> some View { error.view }
}
