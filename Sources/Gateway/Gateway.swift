import Vapor

public protocol GatewayProvider {
    func send(_ sms: OutgoingSMS) -> EventLoopFuture<ClientResponse>
}

public struct Gateway: GatewayProvider {
    
    let application: Application
    
    public init (_ app: Application) {
        application = app
    }
}

// MARK: - Configuration

extension Gateway {
    
    struct ConfigurationKey: StorageKey {
        typealias Value = GatewayConfiguration
    }
    
    public var configuration: GatewayConfiguration? {
        get {
            application.storage[ConfigurationKey.self]
        }
        nonmutating set {
            application.storage[ConfigurationKey.self] = newValue
        }
    }
}

// MARK: Send message

extension Gateway {
    /// Send sms
    ///
    /// - Parameters:
    ///   - content: outgoing sms
    ///   - container: Container
    /// - Returns: Future<Response>
    public func send(_ sms: OutgoingSMS) -> EventLoopFuture<ClientResponse> {
        guard let configuration = self.configuration else {
            fatalError("Gateway not configured. Use app.gateway.configuration = ...")
        }
        
        return application.eventLoopGroup.future().flatMapThrowing { _ -> HTTPHeaders in
            let apiTokenEncoded = try self.encode(apiToken: configuration.apiToken)
            var headers = HTTPHeaders()
            headers.add(name: .authorization, value: "Basic \(apiTokenEncoded)")
            return headers
        }
        .flatMap { headers in
            let gatewayURI = URI(string: "https://gatewayapi.com/rest/mtsms")
            return self.application.client.post(gatewayURI, headers: headers) {
                try $0.content.encode(sms, as: .json)
            }
        }
    }
}

// MARK: Private

fileprivate extension Gateway {
    
    func encode(apiToken: String) throws -> String {
        guard let apiTokenData = "\(apiToken):".data(using: .utf8) else {
            throw GatewayError.encodingProblem
        }
        let authKey = apiTokenData.base64EncodedData()
        guard let authKeyEncoded = String.init(data: authKey, encoding: .utf8) else {
            throw GatewayError.encodingProblem
        }
        return authKeyEncoded
    }
}

extension Application {
    public var gateway: Gateway { .init(self) }
}

extension Request {
    public var gateway: Gateway { .init(application) }
}
