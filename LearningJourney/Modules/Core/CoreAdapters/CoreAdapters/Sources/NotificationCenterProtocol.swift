import Foundation

public protocol NotificationCenterProtocol {
    typealias NotificationName = NSNotification.Name
    typealias Payload = [AnyHashable : Any]?
    
    func addObserver(_ observer: Any, selector: Selector, name: NotificationName)
    func post(name: NotificationName, payload: Payload)
    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterProtocol {
    public func addObserver(_ observer: Any, selector: Selector, name: NotificationName) {
        addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    public func post(name: NotificationName, payload: Payload) {
        post(name: name, object: nil, userInfo: payload)
    }
}

