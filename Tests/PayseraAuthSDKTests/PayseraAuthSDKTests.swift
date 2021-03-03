import XCTest
import PayseraAuthSDK

class PayseraAuthSDKTests: XCTestCase {
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
    
    func testCreateSystemTokenOptional() {
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
    
    func testCreateSystemTokenCollectionOptional() {
        let authToken = ""
        let expectation = XCTestExpectation(description: "Create System Optional Token Collection")
        
        let first = PSSystemToken()
        first.audience = "evpbank"
        first.scope = "logged_in"
        
        let second = PSSystemToken()
        second.audience = "mokejimai"
        second.scope = "logged_in"
        
        let tokens = [first, second]
        
        client.createSystemTokenCollectionOptional(authToken: authToken, tokens: tokens)
            .done { result in
                print(result)
            }.catch { error in
                print(error)
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(expectation)
    }
    
    func testCreateSystemTokenScopeChallenge() {
        let authToken = ""
        let identifier = ""
        let expectation = XCTestExpectation(description: "Should create system token using identifier")
        var response: PSSystemToken?
        
        client
            .createSystemTokenScopeChallenge(authToken: authToken, identifier: identifier)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }

        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
}
