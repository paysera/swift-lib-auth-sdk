import Foundation
import ObjectMapper

public class PSSystemToken: Mappable {
    private var value: String?
    private var expiresIn: Int?
    private var scope: String?
    private var audience: String?
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        value     <- map["value"]
        expiresIn <- map["expires_in"]
        scope     <- map["scope"]
        audience  <- map["audience"]
    }
}
