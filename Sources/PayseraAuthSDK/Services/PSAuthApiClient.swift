import Alamofire
import Foundation
import PayseraCommonSDK
import PromiseKit
import ObjectMapper

public class PSAuthApiClient {
    private let session: Session
    private let logger: PSLoggerProtocol?
    
    private let workQueue = DispatchQueue(label: "\(PSAuthApiClient.self)")
    
    public init(session: Session, logger: PSLoggerProtocol? = nil) {
        self.session = session
        self.logger = logger
    }
    
    public func invalidateAuthToken(authToken: String) -> Promise<Any> {
        let request = createRequest(.invalidateAuthToken(authToken: authToken))
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
    }
    
    public func createSystemTokenOptional(
        authToken: String,
        audience: String,
        scope: String
    ) -> Promise<PSSystemToken> {
        let request = createRequest(
            .createSystemTokenOptional(authToken: authToken, audience: audience, scope: scope)
        )
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .then(on: workQueue, createPromise)
    }
    
    public func createSystemTokenCollectionOptional(
        authToken: String,
        tokens: [PSSystemToken]
    ) -> Promise<[PSSystemToken]> {
        let request = createRequest(
            .createSystemTokenCollectionOptional(authToken: authToken, tokens: tokens)
        )
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .then(on: workQueue, createPromiseWithArrayResult)
    }
    
    public func createSystemTokenScopeChallenge(authToken: String, identifier: String) -> Promise<PSSystemToken> {
        let request = createRequest(.createSystemTokenScopeChallenge(authToken: authToken, identifier: identifier))
        executeRequest(request)
        
        return request
            .pendingPromise
            .promise
            .then(on: workQueue, createPromise)
    }
    
    public func cancelAllOperations() {
        session.cancelAllRequests()
    }
    
    // MARK: - Private request methods
    private func executeRequest(_ apiRequest: PSAuthApiRequest) {
        workQueue.async {
            self.logger?.log(
                level: .DEBUG,
                message: "--> \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString)"
            )
            
            self.session
                .request(apiRequest.requestEndPoint)
                .responseJSON(queue: self.workQueue) { response in
                    self.handleResponse(response, for: apiRequest)
                }
        }
    }
    
    private func handleResponse(
        _ response: AFDataResponse<Any>,
        for apiRequest: PSAuthApiRequest
    ) {
        let responseData = try? response.result.get()
        
        guard let statusCode = response.response?.statusCode else {
            let error = mapError(body: responseData)
            return apiRequest.pendingPromise.resolver.reject(error)
        }
        
        let logMessage = "<-- \(apiRequest.requestEndPoint.urlRequest!.url!.absoluteString) (\(statusCode))"
        
        if 200 ... 299 ~= statusCode {
            logger?.log(level: .DEBUG, message: logMessage)
            apiRequest.pendingPromise.resolver.fulfill(responseData ?? "")
        } else {
            logger?.log(level: .ERROR, message: logMessage)
            let error = mapError(body: responseData)
            apiRequest.pendingPromise.resolver.reject(error)
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
    
    private func mapError(body: Any?) -> PSApiError {
        Mapper<PSApiError>().map(JSONObject: body) ?? .unknown()
    }
    
    private func createRequest(_ endpoint: PSAuthApiRequestRouter) -> PSAuthApiRequest {
        PSAuthApiRequest(
            pendingPromise: Promise<Any>.pending(),
            requestEndPoint: endpoint
        )
    }
}
