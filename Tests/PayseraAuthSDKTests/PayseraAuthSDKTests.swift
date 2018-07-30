import Foundation
import XCTest
import PayseraAuthSDK
import PromiseKit
import JWTDecode
import ObjectMapper

class AuthSDKTests: XCTestCase {
    private var client: PSAuthApiClient!
    
    override func setUp() {
        super.setUp()
        
        self.client = createClient()
    }
    
    func createClient() -> PSAuthApiClient {
        return PSAuthApiClientFactory.createAuthApiClient()
    }
    
    func testInvalidateAuthToken() {
        let authToken = ""
        let expectation = XCTestExpectation(description: "Invalidate Auth Token Expectation")

        client.invalidateAuthToken(authToken: authToken)
            .done { result in
            print(result)
            }.catch { error in
                print(error)
        }

        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(expectation)
    }
    
    func testCreateSystemOptionalToken() {
        let authToken = ""
        let expectation = XCTestExpectation(description: "Create System Optional Token")
        
        client.createSystemTokenOptional(authToken: authToken, audience: "mokejimai", scope: "u:pm:165660 u:fm:165660")
            .done { result in
                print(result)
            }.catch { error in
                print(error)
        }
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(expectation)
    }
}
