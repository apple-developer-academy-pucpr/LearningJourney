import SwiftUI

struct LoginView<ViewModel>: View where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        Button("Sign in with Apple") {
            viewModel.handleSignInWithApple()
        }
    }
}
