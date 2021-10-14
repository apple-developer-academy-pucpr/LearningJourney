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
            .navigationBarItems(trailing: signOutButton)
            .onAppear(perform: viewModel.handleOnAppear) // TODO this should be replaced by `task`
            .onReceive(notificationCenter.publisher(for: .authDidChange),
                       perform: { _ in viewModel.handleUserDidChange()
            })
        }
    }
    
    // MARK: - Component Views
    
    private var contentView: some View {
        Group {
            switch viewModel.strands {
            case let .result(strands):
                strandsView(using: strands)
            case .loading, .empty:
                LoadingView()
            case let .error(error):
                errorView(for: error)
            }
        }
    }
    
    private var signOutButton: some View {
        Button("Signout", action: viewModel.handleSignout)
    }
    
    private func strandsView(using strands: [LearningStrand]) -> some View {
        ScrollView {
            VStack {
//                searchBar
//                    .padding(.vertical, 18)
                ForEach(strands) { strand in
                    LearningStrandRow(
                        service: routingService,
                        strand: strand)
                        .padding(.top)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 80)
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
