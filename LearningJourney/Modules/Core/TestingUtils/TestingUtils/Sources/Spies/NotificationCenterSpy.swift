import CoreAdapters

public final class NotificationCenterSpy: NotificationCenterProtocol {
    
    public init() {}
    
    public func addObserver(_ observer: Any, selector: Selector, name: NotificationName) {}
    
    public private(set) var postCallCount = 0
    public private(set) var postNameUsed: NotificationName?
    public private(set) var postPayloadUsed: Payload?
    
    public func post(name: NotificationName) {
        post(name: name, payload: nil)
    }
    
    public func post(name: NotificationName, payload: Payload?) {
        postCallCount += 1
        postNameUsed = name
        postPayloadUsed = payload
    }
    
    public func removeObserver(_ observer: Any) {}
    
    public func publisher(for name: NotificationName) -> NotificationCenterProtocol.Publisher { NotificationCenter.default.publisher(for: name) }
    
}
