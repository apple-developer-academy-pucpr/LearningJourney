import SwiftUI
import UI
import CoreInjector

struct ObjectivesListView<ViewModel, ObjectiveView>: View where ViewModel: ObjectivesListViewModelProtocol, ObjectiveView: View {
    
    // MARK: - Dependencies
    let routingService: RoutingService
    
    @ObservedObject
    var viewModel: ViewModel
    
    @ViewBuilder
    let objectiveView: (LearningObjective) -> ObjectiveView
    
    
    // MARK: - View
    
    var body: some View {
        contentView
            .navigationTitle(viewModel.goalName)
            .navigationBarItems(trailing: addObjectiveButton)
            
    }
    
    private var addObjectiveButton: some View {
        Button {
            
        } label: {
            Image(systemName: "plus")
        }

    }
    
    private var contentView: some View {
        Group {
            switch viewModel.objectives {
            case .loading, .empty:
                LoadingView()
                    .onAppear(perform: viewModel.handleOnAppear)
            case let .error(error):
                errorView(for: error)
            case let .result(objectives):
                resultView(objectives)
            }
        }
    }
    
    private func resultView(_ objectives: [LearningObjective]) -> some View {
        ScrollView {
            VStack {
                ForEach(objectives) { objective in
                    objectiveView(objective)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#if DEBUG

struct ObjectivesListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Demo")
            .previewDevice(.init(rawValue: "iPhone 12 mini"))
    }
}

#endif
