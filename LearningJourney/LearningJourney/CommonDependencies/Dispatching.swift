import Foundation

public protocol Dispatching {
    func async(_ work: @escaping () -> Void)
}

extension DispatchQueue: Dispatching {
    public func async(_ work: @escaping () -> Void) {
        async(execute: work)
    }
}
