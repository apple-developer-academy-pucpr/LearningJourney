import SwiftUI
import CoreInjector
import UI
import CoreAdapters

struct LibraryView<ViewModel>: View where ViewModel: LibraryViewModelProtocol {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    
    let routingService: RoutingService
    let notificationCenter: NotificationCenterProtocol
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack {
                contentView
            }
            .padding(.leading)
            .navigationTitle("Library")
            .navigationBarItems(trailing: listModeView)
            .onAppear(perform: viewModel.handleOnAppear) // TODO this should be replaced by `task`
            .onReceive(notificationCenter.publisher(for: .authDidChange),
                       perform: { _ in viewModel.handleUserDidChange()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // MARK: - Component Views
    
    
    private var contentView: some View {
        Group {
            switch viewModel.strands {
            case let .result(strands):
                strandsView(using: strands)
            case .loading:
                LoadingView()
            case .empty:
                Text("Please, refresh your login credentials. To do that, go to Settings, your account, Password & Security and Apple ID login, then sign in back in the app")
            case let .error(error):
                errorView(for: error)
            }
        }
    }
    
    private var signOutButton: some View {
        Button("Signout", action: viewModel.handleSignout)
            .foregroundColor(.red)
    }
    
    @ViewBuilder
    private func strandsView(using strands: [LearningStrand]) -> some View {
        ScrollView {
            VStack {
                if viewModel.isList {
                    buildListView(using: strands)
                } else {
                    buildCollectionView(using: strands)
                }
                signOutButton
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 20, trailing: 0))
            }
            .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    private func buildCollectionView(using strands: [LearningStrand]) -> some View {
        ForEach(strands) { strand in
            LearningStrandRow(
                service: routingService,
                strand: strand)
                .padding(.top)
        }
    }
    
    @ViewBuilder
    private func buildListView(using strands: [LearningStrand]) -> some View {
        ForEach(strands) { strand in
            HStack {
                Text(strand.name)
                    .font(.system(size: 19))
                    .bold()
                    .padding(.top, 24)
                Spacer()
            }
            .padding(.bottom, 16)
            ForEach(strand.goals) { goal in
                GroupBox {
                    routingService.link(for: ObjectivesRoute(goal: goal)) {
                        HStack {
                            Spacer()
                            Text(goal.name)
                            Spacer()
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.trailing)
            }
        }
    }
    
    private var listModeView: some View {
        Button(viewModel.isList ? "List" : "Groups") {
            viewModel.togglePresentationMode()
        }
    }
    
    private var searchBar: some View {
        TextField(
            "Search",
            text: $viewModel.searchQuery)
    }
}

public extension Notification.Name {
    static let authDidChange: Notification.Name = .init("authdidchange")
}

extension PresentationMode: Equatable {
    public static func == (lhs: PresentationMode, rhs: PresentationMode) -> Bool {
        lhs.isPresented == rhs.isPresented
    }
}

#if DEBUG

struct ContentView_Previews: PreviewProvider {
    
    static var contentPreview: some View {
            LibraryView<LibraryViewModelMock>(viewModel: LibraryViewModelMock(resultToUse: [
                .fixture(goals: [
                            .fixture(),
                            .fixture(),
                            .fixture(),
                ]),
                .fixture(goals: [
                    .fixture(),
                    .fixture(),
                    .fixture(),
                ]),
                .fixture(goals: [
                    .fixture(),
                    .fixture(),
                    .fixture(),
                ]),
                .fixture(goals: [
                    .fixture(),
                    .fixture(),
                    .fixture(),
                ]),
            ]), routingService: DummyRoutingService(), notificationCenter: NotificationCenter.dummy)
        
    }
    
    static var previews: some View { contentPreview }
}

final class DummyRoutingService: RoutingService {
    func feature(for featureType: Feature.Type) -> Feature { DummyFeature() }
    
    func register<T>(_ factory: @escaping DependencyFactory, for type: T.Type) {}
    
    func register(routeHandler: RouteHandling) {}
    
    func initialize(using feature: Feature.Type) -> AnyView { AnyView(Text("Dummy")) }
    
    func link<Body>(for route: Route, body: () -> Body) -> NavigationLink<Body, AnyView> where Body : View {
        NavigationLink(
            destination: AnyView(Text("Destination")),
            label: body)
    }
}

struct DummyFeature: Feature {
    func build(using route: Route?) -> AnyView { AnyView(Text("Dummy")) }
}

#endif
