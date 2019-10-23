import Foundation
import Alamofire
import ObjectMapper
import PromiseKit
import PayseraCommonSDK

public class PSAuthApiClient {
    private let sessionManager: SessionManager
    private let logger: PSLoggerProtocol?
    
    public init(sessionManager: SessionManager, logger: PSLoggerProtocol? = nil) {
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    public func invalidateAuthToken(authToken: String) -> Promise<Any> {
        let request = createRequest(.invalidateAuthToken(authToken: authToken))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func createSystemTokenOptional(authToken: String, audience: String, scope: String) -> Promise<PSSystemToken> {
        let request = createRequest(.createSystemTokenOptional(authToken: authToken, audience: audience, scope: scope))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromise)
    }
    
    public func createSystemTokenCollectionOptional(authToken: String, tokens: [PSSystemToken]) -> Promise<[PSSystemToken]> {
        let request = createRequest(.createSystemTokenCollectionOptional(authToken: authToken, tokens: tokens))
        makeRequest(apiRequest: request)
        
        return request
            .pendingPromise
            .promise
            .then(createPromiseWithArrayResult)
    }
    
    // MARK: - Private request methods
    private func makeRequest(apiRequest: PSAuthApiRequest) {
        self.logger?.log(level: .DEBUG, message: "--> \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)")
        
        sessionManager
            .request(apiRequest.requestEndPoint)
            .responseJSON { (response) in
                var logMessage = "<-- \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)"
                if let statusCode = response.response?.statusCode {
                    logMessage += " (\(statusCode))"
                }
                
                
                let responseData = response.result.value
                
                guard let statusCode = response.response?.statusCode else {
                    let error = self.mapError(body: responseData)
                    apiRequest.pendingPromise.resolver.reject(error)
                    return
                }
                
                if statusCode >= 200 && statusCode < 300 {
                    self.logger?.log(level: .DEBUG, message: logMessage)
                    apiRequest.pendingPromise.resolver.fulfill(responseData)
                } else {
                    self.logger?.log(level: .ERROR, message: logMessage)
                    let error = self.mapError(body: responseData)
                    apiRequest.pendingPromise.resolver.reject(error)
                }
        }
    }
    
    private func createPromiseWithArrayResult<T: Mappable>(body: Any) -> Promise<[T]> {
        guard let objects = Mapper<T>().mapArray(JSONObject: body) else {
            return Promise(error: mapError(body: body))
        }
        return Promise.value(objects)
    }
    
    private func createPromise<T: Mappable>(body: Any) -> Promise<T> {
        guard let object = Mapper<T>().map(JSONObject: body) else {
            return Promise(error: mapError(body: body))
        }
        return Promise.value(object)
    }
    
    private func createPromise(body: Any) -> Promise<Any> {
        return Promise.value(body)
    }
    
    private func mapError(body: Any?) -> PSApiError {
        if let apiError = Mapper<PSApiError>().map(JSONObject: body) {
            return apiError
        }
        
        return PSApiError.unknown()
    }
    
    private func createRequest(_ endpoint: PSAuthApiRequestRouter) -> PSAuthApiRequest {
        return PSAuthApiRequest(
            pendingPromise: Promise<Any>.pending(),
            requestEndPoint: endpoint
        )
    }
}
