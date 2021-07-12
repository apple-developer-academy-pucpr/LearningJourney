import AuthenticationServices

protocol ASAuthorizationProtocol {
    var credential: ASAuthorizationCredential { get }
}

protocol ASAuthorizationAppleIDCredentialProtocol {
    var identityToken: Data? { get }
    var user: String { get }
    var fullName: PersonNameComponents? { get }
    var email: String? { get }
}

extension ASAuthorization: ASAuthorizationProtocol {}
extension ASAuthorizationAppleIDCredential: ASAuthorizationAppleIDCredentialProtocol {}

