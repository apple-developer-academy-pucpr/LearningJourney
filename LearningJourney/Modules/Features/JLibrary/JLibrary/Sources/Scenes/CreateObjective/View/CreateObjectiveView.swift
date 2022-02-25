import SwiftUI

struct CreateObjectiveView<ViewModel>: View where ViewModel: CreateObjectiveViewModelProtocol {
    
    let viewModel: ViewModel
    
    var body: some View {
        Button {
            viewModel.didTapOnCreate()
        } label: {
            Text("TEsta ai")
        }
    }
}
