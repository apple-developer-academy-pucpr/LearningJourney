import Foundation

public typealias DependencyFactory = () -> AnyObject

public protocol DependencyContainer {
    func make<T>(_ type: T.Type) -> T?
    func register<T>(factory: @escaping DependencyFactory, for type: T.Type)
}

public final class DefaultDependencyContainer: DependencyContainer {
    
    // MARK: - Properties
    
    private var dependencies = NSMapTable<NSString, AnyObject>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory)
    
    private var dependencyCreators = [NSString : DependencyFactory]()
    
    // MARK: - Container methods
    
    public func make<T>(_ type: T.Type) -> T? {
        let name = name(for: type)
        let object = dependencies.object(forKey: name as NSString)
        
        if object != nil { return object as? T }
        
        guard let instance = dependencyCreators[name]?()
        else { return nil }
        
        dependencies.setObject(instance, forKey: name as NSString)
        return instance as? T
    }
    
    public func register<T>(factory: @escaping DependencyFactory, for type: T.Type) {
        let name = name(for: type)
        dependencyCreators[name] = factory
    }
    
    // MARK: - Helpers
    
    private func name<T>(for type: T.Type) -> NSString { String(describing: type) as NSString }
}
