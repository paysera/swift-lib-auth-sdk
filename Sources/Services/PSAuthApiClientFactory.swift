import Foundation
import Alamofire

public class PSAuthApiClientFactory {
    public static func createAuthApiClient() -> PSAuthApiClient {
        return PSAuthApiClient(sessionManager: SessionManager())
    }
}
