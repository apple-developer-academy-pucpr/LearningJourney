protocol Resolvable {}

public enum DependencyInjectionError<T>: Error {
    case unresolvedYet(_ forType: T.Type)
    case resolvedTwice(_ forType: T.Type)
    case notRegistered(_ forType: T.Type)
}

func myErrorHandler(_ error: Error) -> Never {
    fatalError("salve")
}

@propertyWrapper
public final class Dependency<T>: Resolvable {
    
    public typealias ErrorHandler = (DependencyInjectionError<T>) -> Never

    private let errorHandler: ErrorHandler
    private var resolvedValue: T?
    
    public var wrappedValue: T {
        guard let resolved = resolvedValue else {
            errorHandler(.unresolvedYet(T.self))
        }
        return resolved
    }
    
    public init(
        resolvedValue: T? = nil,
        errorHandler: @escaping ErrorHandler = { preconditionFailure($0.localizedDescription) }
    ) {
        self.resolvedValue = resolvedValue
        self.errorHandler = errorHandler
    }
    
    func resolve(using container: DependencyContainer) {
        guard resolvedValue == nil else {
            errorHandler(.resolvedTwice(T.self))
        }
        guard let value = container.make(T.self) else {
            errorHandler(.notRegistered(T.self))
        }
        resolvedValue = value
    }
}
