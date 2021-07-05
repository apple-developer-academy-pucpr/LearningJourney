import SwiftUI
import AuthenticationServices

struct LoginView<ViewModel>: View where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        SignInWithAppleButton(
            onRequest: viewModel.handleRequest,
            onCompletion: viewModel.handleCompletion
        )
    }
}
