import SwiftUI

protocol LoginAssembling {
    func assemble() -> AnyView
}

final class LoginAssembler: LoginAssembling {
    func assemble() -> AnyView {
        let view = LoginView()
        return AnyView(view)
    }
}
