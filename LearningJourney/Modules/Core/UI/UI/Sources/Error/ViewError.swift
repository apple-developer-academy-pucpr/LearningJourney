import SwiftUI

public enum ViewError: Equatable {
    case notAuthenticated
    case unknown (UnknownErrorCallback)
    
    public static func == (lhs: ViewError, rhs: ViewError) -> Bool {
        switch lhs {
        case .notAuthenticated:
            return rhs == .notAuthenticated
        case .unknown:
            if case .unknown = rhs {
                return true
            }
        }
        return false
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
