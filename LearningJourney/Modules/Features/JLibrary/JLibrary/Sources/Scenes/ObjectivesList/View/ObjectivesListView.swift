import SwiftUI
import UI

struct ObjectivesListView<ViewModel>: View where ViewModel: ObjectivesListViewModelProtocol {
    
    // MARK: - Dependencies
    
    @ObservedObject var viewModel: ViewModel
    
    // MARK: - View
    
    var body: some View {
        contentView
            .navigationTitle(viewModel.goalName)
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
    
    private func resultView(_ objectives: [LibraryViewModelState<LearningObjective>]) -> some View {
        ScrollView {
            VStack {
                ForEach(objectives) { objective in
                    ObjectiveCard(objective: objective) {
                        viewModel.handleDidLearnToggled(objective: objective)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}

#if DEBUG

struct ObjectivesListView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectivesListView<ObjectivesListViewModelMock>(viewModel: ObjectivesListViewModelMock())
            .previewDevice(.init(rawValue: "iPhone 12 mini"))
    }
}

#endif
