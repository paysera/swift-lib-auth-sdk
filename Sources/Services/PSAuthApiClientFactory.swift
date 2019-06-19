import Foundation
import Alamofire
import PayseraCommonSDK

public class PSAuthApiClientFactory {
    public static func createAuthApiClient(logger: PSLoggerProtocol? = nil) -> PSAuthApiClient {
        return PSAuthApiClient(sessionManager: SessionManager(), logger: logger)
    }
}
