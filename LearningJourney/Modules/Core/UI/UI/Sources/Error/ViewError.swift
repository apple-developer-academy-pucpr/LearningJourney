import SwiftUI

public enum ViewError: Equatable {
    public typealias SignOutCallback = () -> Void
    
    case notAuthenticated(SignOutCallback)
    case unknown (UnknownErrorCallback)
    
    public static let notAuthenticated: Self = .notAuthenticated({})
    
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
    var view: some View {
        Group {
            switch self {
            case let .notAuthenticated(callback):
                Button("Signout", action: callback)
            case let .unknown (callback):
                UnknownErrorView(action: callback)
            }
        }
    }
}

public extension View {
    func errorView(for error: ViewError) -> some View { error.view }
}
