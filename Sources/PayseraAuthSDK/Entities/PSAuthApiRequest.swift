import PromiseKit

class PSAuthApiRequest {
    let requestEndPoint: PSAuthApiRequestRouter
    let pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>)
    
    init(
        pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>),
        requestEndPoint: PSAuthApiRequestRouter
    ) {
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }   
}
