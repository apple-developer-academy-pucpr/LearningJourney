import SwiftUI
import AuthenticationServices
import CoreInjector
import UI
import CoreAdapters

struct LoginView<ViewModel>: View where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    
    @Environment (\.colorScheme)
    var colorScheme
    
    // MARK: - View
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                LoadingView()
            case .error:
                Text("Oops! There was an error!")
            case .result:
                contentView
            }
        }
        .alert(isPresented: $viewModel.isShowingSIWAAlert) {
            Alert(
                title: Text("Please, remove this app from the apps that are using your Apple ID and try again"),
                message: Text("To do so, please go to your iPhone's configuration -> Your account -> password and security -> Apps using Apple ID -> Learning Journey -> click on Stop using this Apple ID.\nAlso, please be sure that you're sending your name"),
                dismissButton: .cancel(Text("OK")))
        }
    }
    
    // fazer a tela aqui
    
    private var contentView: some View {
        VStack{
            Image(UI.Assets.loginScreenBanner.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()

            VStack (alignment: .leading){
                Text("Your journey starts here")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                VStack (alignment: .leading){
                    FeatureRow(icon: "checkmark.circle", title: "Progress tracking", description: "See what you've already learned.")
                    FeatureRow(icon: "target", title: "Goal mapping", description: "Understand what you still need to work on.")
                }
                
                Spacer()
                SignInWithAppleButton(
                    .continue,
                    onRequest: viewModel.handleRequest,
                    onCompletion: viewModel.handleCompletion
                )
                .frame(height: 50)
                .cornerRadius(10)
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black )
            }
            .padding(30)
        }
    }
}

struct LoginPresentationModifier<ViewModel>: ViewModifier where ViewModel: LoginViewModeling {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    let loginView: AnyView
    let notificationCenter: NotificationCenterProtocol
    
    // MARK: - ViewModifier
    
    func body(content: Content) -> some View {
        content
            .onAppear(perform: viewModel.handleOnAppear)
            .onReceive(
                notificationCenter.publisher(for: .authDidChange),
                perform: viewModel.handleAuthStatusChange)
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                loginView
            }
    }
}

public extension View {
    func authenticationSheet(using feature: Feature) -> some View {
        guard let feature = feature as? AuthenticationFeature else {
            fatalError("Tried to assemble using wrong feature!")
        }
        let view = LoginAssembler().assemble(using: feature)
        return modifier(LoginPresentationModifier(
            viewModel: view.viewModel,
            loginView: AnyView(view),
            notificationCenter: feature.notificationCenter
        ))
    }
}

#if DEBUG
struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModelMock())
            .preferredColorScheme(.dark)
    }
}
#endif
