import Foundation
import ObjectMapper

public class PSSystemToken: Mappable {
    public var value: String?
    public var expiresIn: Int?
    public var scope: String?
    public var audience: String?
    
    public init() {}
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        value     <- map["value"]
        expiresIn <- map["expires_in"]
        scope     <- map["scope"]
        audience  <- map["audience"]
    }
}
