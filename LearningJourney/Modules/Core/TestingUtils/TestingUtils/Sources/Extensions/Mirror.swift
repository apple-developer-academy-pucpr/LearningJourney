import Foundation

extension Mirror {
    public func firstChild<T>(named: String) -> T? {
        children.first(where:{ $0.label == named })?.value as? T
    }
}

