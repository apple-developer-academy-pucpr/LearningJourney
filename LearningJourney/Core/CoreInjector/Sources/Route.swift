public protocol Route {
    static var identifier: String { get }
}

public protocol RouteHandling {
    var routes: [Route.Type] { get }
    
    func destination(for route: Route) -> Feature.Type
}
