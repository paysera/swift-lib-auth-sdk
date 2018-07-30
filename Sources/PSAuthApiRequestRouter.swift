import Foundation
import Alamofire

public enum PSAuthApiRequestRouter: URLRequestConvertible {
    
    case invalidateAuthToken(authToken: String)
    case createSystemTokenOptional(authToken: String, audience: String, scope: String)
    
    // MARK: - Declarations
    static var baseURLString = "https://auth-api.paysera.com/authentication/rest/v1"
    
    private var authToken: String {
        switch self {
            case .invalidateAuthToken(let authToken),
                 .createSystemTokenOptional(let authToken, _, _):
                return authToken
            }
        
    }
    
    private var method: HTTPMethod {
        switch self {
            case .invalidateAuthToken( _):
                return .delete
            case .createSystemTokenOptional(_, _, _):
                return .post
        }
    }
    
    private var path: String {
        switch self {
            case .invalidateAuthToken( _):
                return "/auth-tokens/current"
            case .createSystemTokenOptional( _, _, _):
                return "/system-tokens/optional"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
            case .createSystemTokenOptional(_, let audience, let scope):
                return ["audience": audience, "scope": scope]
            default:
                return nil
        }
    }
    
    // MARK: - Method
    public func asURLRequest() throws -> URLRequest {
        let url = try! PSAuthApiRequestRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {    
            case (_) where method == .get:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            
            case (_) where method == .post:
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
            case (_) where method == .put:
                urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
            default:
                urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
