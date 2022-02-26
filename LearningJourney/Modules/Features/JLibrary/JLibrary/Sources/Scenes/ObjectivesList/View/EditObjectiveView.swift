import SwiftUI

struct EditObjectiveView: View {
    
    let didStartEditing: () -> Void
    let didDelete: () -> Void
    let didFinishEditing: () -> Void
    let didCancelEditing: () -> Void
    
    @State
    private var isEditing: Bool = false
    
    @Binding
    var loadingState: LibraryViewModelState<LearningStatusButtonState>
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(hex: "#F2F2F7"))
                .frame(height: 1.5)
            contentView
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .padding(.top, 12)
                .redacted(reason: loadingState == .loading ? .placeholder : [])
        }
        .background(isEditing ? Color(hex: "#F2F2F7") : .white)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if isEditing {
            HStack {
                Button(action: didDelete) {
                    Label {
                        Text("Deletar")
                            .font(.system(size: 13, weight: .semibold))
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
                .foregroundColor(.red)
                
                Spacer()
                Button {
                    didCancelEditing()
                    isEditing = false
                } label: {
                    Text("Cancelar")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Button {
                    didFinishEditing()
                    isEditing = false
                } label: {
                    Text("OK")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
        } else {
            HStack {
                Spacer()
                editButton
                Spacer()
            }
        }
    }
    
    private var editButton: some View {
        Button {
            isEditing = true
            didStartEditing()
        } label: {
            Label {
                Text("Editar")
            } icon: {
                Image(systemName: "square.and.pencil")
            }

        }

    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: .init(width: radius, height: radius)).cgPath)
    }
}
