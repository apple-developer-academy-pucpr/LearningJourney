import SwiftUI
import UI

struct CreateObjectiveView<ViewModel>: View where ViewModel: CreateObjectiveViewModelProtocol {
    
    private enum FocusField: Hashable {
        case description
    }
    
    @ObservedObject
    var viewModel: ViewModel
    
    @FocusState
    private var focusedField: FocusField?
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                Group {
                    switch viewModel.state {
                    case .loading, .empty:
                        LoadingView()
                            .onAppear {
                                viewModel.handleAppear()
                            }
                    case let .error(error):
                        errorView(for: error)
                    case let .result(metadata):
                        buildContentView(using: metadata)
                    }
                }
                .navigationTitle("Criar Objetivo")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: cancelButton, trailing: createButton)
                .navigationViewStyle(.columns)
            }
        }
    }
    
    @ViewBuilder
    private var cancelButton: some View {
        Button {
            viewModel.didTapOnCancel()
        } label: {
            Text("Cancelar")
        }

    }
    
    @ViewBuilder
    private var createButton: some View {
        Group {
            switch viewModel.createButtonState {
            case .loading:
                LoadingView(style: .medium)
            case .disabled, .enabled:
                Button {
                    viewModel.didTapOnCreate()
                } label: {
                    Text("Criar")
                }
                .disabled(viewModel.createButtonState == .disabled)
            }
        }
    }
    
    @ViewBuilder
    private func buildContentView(using metadata: NewObjectiveMetadata) -> some View {
        VStack(spacing: 8) {
            disabledTextField(metadata.strandName)
            disabledTextField(metadata.goalName)
            disabledTextField(metadata.code)
            BridgedTextField("Descrição", text: $viewModel.currentDescription) {
                viewModel.descriptionDidCommit()
            }
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(hex: "#007AFF"), lineWidth: 1.5))
                .focused($focusedField, equals: .description)
                .onAppear {
                    self.focusedField = .description
                }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func disabledTextField(_ text: String) -> some View {
        HStack {
            Text(text)
                .padding(.leading)
                .foregroundColor(.init(hex: "#979798"))
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color(uiColor: .black.withAlphaComponent(0.02)))
        .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#F2F2F7"), lineWidth: 1))
    }
}
