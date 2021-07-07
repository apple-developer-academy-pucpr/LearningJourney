import SwiftUI

public enum ViewError {
    case notAuthenticated
    case unknown
}


public extension ViewError {
    var view: AnyView {
        switch self {
        case .notAuthenticated:
            return AnyView(Text("salve"))
        case .unknown:
           return AnyView(UnknownErrorView())
        }
    }
}

public extension View {
    func errorView(for error: ViewError) -> some View { error.view }
}
