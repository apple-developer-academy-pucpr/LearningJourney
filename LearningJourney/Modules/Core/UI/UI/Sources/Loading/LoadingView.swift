import SwiftUI

public struct LoadingView: View {
    
    private let style: UIActivityIndicatorView.Style
    
    public init(style: UIActivityIndicatorView.Style = .large) {
        self.style = style
    }
    
    public var body: some View {
        ActivityIndicator(
            isAnimating: .constant(true), style: style)
    }
}

struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
