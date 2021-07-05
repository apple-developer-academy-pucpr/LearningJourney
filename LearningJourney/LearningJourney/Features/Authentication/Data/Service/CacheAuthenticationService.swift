protocol CacheAuthenticationServicing {
    var hasToken: TokenPayload? { get }
    func cache(token: TokenPayload)
}

final class CacheAuthenticationService: CacheAuthenticationServicing {
    var hasToken: TokenPayload? { nil }
    
    func cache(token: TokenPayload) {
        <#code#>
    }
}
