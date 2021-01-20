import Foundation
import Alamofire
import PayseraCommonSDK

public class PSAuthApiClientFactory {
    public static func createAuthApiClient(logger: PSLoggerProtocol? = nil) -> PSAuthApiClient {
        let session = Session()
        return PSAuthApiClient(session: session, logger: logger)
    }
}
