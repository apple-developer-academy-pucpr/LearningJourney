import Foundation

public protocol NotificationCenterProtocol {
    typealias NotificationName = NSNotification.Name
    typealias Payload = [AnyHashable : Any]
    typealias Publisher = NotificationCenter.Publisher
    
    func addObserver(_ observer: Any, selector: Selector, name: NotificationName)
    func post(name: NotificationName)
    func post(name: NotificationName, payload: Payload?)
    func removeObserver(_ observer: Any)
    func publisher(for name: NotificationName) -> Publisher
}

extension NotificationCenter: NotificationCenterProtocol {
    
    public func addObserver(_ observer: Any, selector: Selector, name: NotificationName) {
        addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    public func post(name: NotificationName) {
        post(name: name, payload: nil)
    }
    
    public func post(name: NotificationName, payload: Payload?) {
        post(name: name, object: nil, userInfo: payload)
    }
    
    public func publisher(for name: NotificationName) -> NotificationCenterProtocol.Publisher {
        publisher(for: name, object: nil)
    }
}

// MARK: - Common notifications

public extension Notification.Name {
    static let authDidChange: Notification.Name = .init("authdidchange")
}

#if DEBUG

public final class NotificationCenterDummy: NotificationCenterProtocol {
    public func addObserver(_ observer: Any, selector: Selector, name: NotificationName) {}
    
    public func post(name: NotificationName) {}
    
    public func post(name: NotificationName, payload: Payload?) {}
    
    public func removeObserver(_ observer: Any) {}
    
    public func publisher(for name: NotificationName) -> NotificationCenterProtocol.Publisher {
        .init(center: .init(), name: .init("dummy"))
    }
}

extension NotificationCenter {
    public static let dummy = NotificationCenterDummy()
}

#endif
