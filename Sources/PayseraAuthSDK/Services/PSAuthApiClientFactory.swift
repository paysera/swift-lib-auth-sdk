import Foundation
import Alamofire
import PayseraCommonSDK

public class PSAuthApiClientFactory {
    public static func createAuthApiClient(logger: PSLoggerProtocol? = nil) -> PSAuthApiClient {
        let trustedSession = PSTrustedSession(interceptor: nil, hosts: ["auth-api.paysera.com"])
        return PSAuthApiClient(session: trustedSession, logger: logger)
    }
}
