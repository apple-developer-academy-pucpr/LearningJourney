import Foundation

public typealias DependencyFactory = () -> AnyObject

public protocol DependencyContainer {
    func make<T>(_ type: T.Type) -> T?
    func register<T>(factory: @escaping DependencyFactory, for type: T.Type)
}

public final class DefaultDependencyContainer: DependencyContainer {
    
    // MARK: - Properties
    
    private var dependencyFactories = [NSString : DependencyFactory]()
    private var dependencies = NSMapTable<NSString, AnyObject>(
        keyOptions: .strongMemory,
        valueOptions: .weakMemory)
    
    
    // MARK: - Container methods
    
    public func make<T>(_ type: T.Type) -> T? {
        let name = name(for: type)
        let object = dependencies.object(forKey: name)
        
        if object != nil { return object as? T }
        
        guard let instance = dependencyFactories[name]?()
        else { return nil }
        
        dependencies.setObject(instance, forKey: name)
        return instance as? T
    }
    
    public func register<T>(factory: @escaping DependencyFactory, for type: T.Type) {
        let name = name(for: type)
        dependencyFactories[name] = factory
    }
    
    // MARK: - Helpers
    
    private func name<T>(for type: T.Type) -> NSString { String(describing: type) as NSString }
}
