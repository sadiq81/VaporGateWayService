import Vapor
import Gateway

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    app.gateway.configuration = .environment
    
    try routes(app)
}
