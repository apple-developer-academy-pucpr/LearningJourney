import SwiftUI
import CoreInjector

struct LibraryView<ViewModel>: View where ViewModel: LibraryViewModelProtocol {
    
    // MARK: - Dependencies
    
    @ObservedObject
    var viewModel: ViewModel
    
    let routingService: RoutingService
    
    // MARK: - View
    var body: some View {
        NavigationView {
            VStack {
                contentView
            }
            .padding(.leading)
            .navigationTitle("Library")
            .onAppear(perform: viewModel.handleOnAppear)
            .onReceive(NotificationCenter.default.publisher(for: .authDidChange), perform: { _ in
                viewModel.handleUserDidChange() // TODO this should be replaced by `task`
            })
        }
    }
    
    // MARK: - Component Views
    
    private var contentView: some View {
        Group {
            switch viewModel.strands {
            case let .result(strands):
                strandsView(using: strands)
            case .loading:
                Text("Loading")
            case let .error(error):
                errorView(for: error)
            }
        }
    }
    
    private func strandsView(using strands: [LearningStrand]) -> some View {
        ScrollView {
            VStack {
                searchBar
                    .padding(.vertical, 18)
                ForEach(strands) { strand in
                    LearningStrandRow(service: routingService, strand: strand)
                    Spacer()
                        .frame(height: 20)
                }
            }
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
    static var previews: some View {
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
        ]), routingService: DummyRoutingService())
    }
}

final class DummyRoutingService: RoutingService {
    func register<T>(_ factory: @escaping DependencyFactory, for type: T.Type) {}
    
    func register(routeHandler: RouteHandling) {}
    
    func initialize(using feature: Feature.Type) -> AnyView { AnyView(Text("Dummy")) }
    
    func link<Body>(for route: Route, body: () -> Body) -> NavigationLink<Body, AnyView> where Body : View {
        NavigationLink(
            destination: AnyView(Text("Destination")),
            label: body)
    }
}

#endif
