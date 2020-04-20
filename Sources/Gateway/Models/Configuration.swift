import Vapor

public struct GatewayConfiguration {
    
    public let apiToken: String
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - apiToken: Account ID provided by GateWay.com
    public init(apiToken: String) {
        self.apiToken = apiToken
    }
    
    /// It will try to initialize configuration with environment variables:
    /// - GATEWAY_API_TOKEN
    public static var environment: GatewayConfiguration {
        guard let apiToken = Environment.get("GATEWAY_API_TOKEN") else { fatalError("Gateway environmant variables not set") }
        return GatewayConfiguration(apiToken: apiToken)
    }
}
