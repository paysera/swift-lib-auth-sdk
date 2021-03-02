import Alamofire
import Foundation

public enum PSAuthApiRequestRouter: URLRequestConvertible {
    
    case invalidateAuthToken(authToken: String)
    case createSystemTokenOptional(authToken: String, audience: String, scope: String)
    case createSystemTokenCollectionOptional(authToken: String, tokens: [PSSystemToken])
    case createSystemTokenScopeChallenge(authToken: String, identifier: String)
    
    // MARK: - Declarations
    static let baseURL = URL(string: "https://auth-api.paysera.com/authentication/rest/v1")!
    
    private var authToken: String {
        switch self {
        case .invalidateAuthToken(let authToken),
             .createSystemTokenOptional(let authToken, _, _),
             .createSystemTokenCollectionOptional(let authToken, _),
             .createSystemTokenScopeChallenge(let authToken, _):
            return authToken
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .invalidateAuthToken:
            return .delete
        case .createSystemTokenOptional,
             .createSystemTokenCollectionOptional,
             .createSystemTokenScopeChallenge:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .invalidateAuthToken:
            return "/auth-tokens/current"
        case .createSystemTokenOptional:
            return "/system-tokens/optional"
        case .createSystemTokenCollectionOptional:
            return "/system-tokens/optional-collection"
        case .createSystemTokenScopeChallenge:
            return "/system-tokens/scope-challenge"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .createSystemTokenOptional(_, let audience, let scope):
            return ["audience": audience, "scope": scope]
        case .createSystemTokenScopeChallenge(_, let identifier):
            return ["identifier": identifier]
        default:
            return nil
        }
    }
    
    // MARK: - Method
    public func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch self {
        case .createSystemTokenCollectionOptional(_, let tokens):
            urlRequest = try ArrayEncoding().encode(urlRequest, with: tokens.toJSON().asParameters())
        
        case _ where method == .post,
             _ where method == .put:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
