import Foundation

protocol AuthenticationParsing {
    func parse<T: Decodable>(_ data: Data) -> Result<T, ParsingError>
}

final class AuthenticationParser: AuthenticationParsing {
    func parse<T: Decodable>(_ data: Data) -> Result<T, ParsingError> {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(.invalidData(error))
        }
    }
}
