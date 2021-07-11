import Foundation

public protocol URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol?
}

public protocol DataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: DataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    public func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskProtocol? {
        dataTask(with: request, completionHandler: completionHandler)
    }
}
