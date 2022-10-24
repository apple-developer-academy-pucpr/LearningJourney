import SwiftUI
import UIKit

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding
    var text: String
    @Binding
    var calculatedHeight: CGFloat
    @Binding
    var isEditingEnabled: Bool
    @Binding
    var shouldBecomeFirstResponder: Bool
    
    var onDone: (() -> Void)?
    let minumumHeight: CGFloat

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = isEditingEnabled
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }
        
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if shouldBecomeFirstResponder {
            uiView.becomeFirstResponder()
        }
        uiView.isEditable = isEditingEnabled
        makeCoordinator().recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, minHeight: minumumHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?
        let minHeight: CGFloat

        init(text: Binding<String>, height: Binding<CGFloat>, minHeight: CGFloat, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
            self.minHeight = minHeight
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                DispatchQueue.main.async {
                    onDone()
                }
                return false
            }
            return true
        }
        
        func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
            let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if result.wrappedValue != newSize.height {
                DispatchQueue.main.async {
                    result.wrappedValue = max(newSize.height, self.minHeight) // !! must be called asynchronously
                }
            }
        }
    }

}

public struct BridgedTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false
    private var isEditingEnabled: Binding<Bool>
    
    
    let shouldBecomeFirstResponder: Binding<Bool>
    let minimumHeight: CGFloat

    public init (_ placeholder: String = "",
                 text: Binding<String>,
                 minimumHeight: CGFloat = 0,
                 isEditingEnabled: Binding<Bool> = .constant(true),
                 shouldBecomeFirstResponder: Binding<Bool> = .constant(true),
                 onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self.minimumHeight = minimumHeight
        self.shouldBecomeFirstResponder = shouldBecomeFirstResponder
        self.isEditingEnabled = isEditingEnabled
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    public var body: some View {
        UITextViewWrapper(text: self.internalText,
                          calculatedHeight: $dynamicHeight,
                          isEditingEnabled: isEditingEnabled,
                          shouldBecomeFirstResponder: shouldBecomeFirstResponder,
                          onDone: onCommit,
                          minumumHeight: self.minimumHeight)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}
