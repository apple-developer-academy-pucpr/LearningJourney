import SwiftUI
import AuthenticationServices

struct LoginView<ViewModel>: View where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                Text("Loading")
            case .error:
                Text("Error")
            case .result:
                contentView
            }
        }
    }
    
    private var contentView: some View {
        SignInWithAppleButton(
            onRequest: viewModel.handleRequest,
            onCompletion: viewModel.handleCompletion
        )
    }
}

struct LoginPresentationModifier<ViewModel>: ViewModifier where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    
    let loginView: AnyView
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: viewModel.handleOnAppear)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                loginView
            }
    }
}

extension View {
    func authenticationSheet(assembler: LoginAssembling) -> some View {
        let view = assembler.assemble()
        return modifier(LoginPresentationModifier(
                        viewModel: view.viewModel,
                        loginView: AnyView(view)))
    }
}
