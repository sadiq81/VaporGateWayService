import Vapor
import Gateway

/// Register your application's routes here.
func routes(_ app: Application) throws {
    // Basic "Hello world" example
    app.get { req -> EventLoopFuture<ClientResponse> in
        let recipient = Recipient(msisdn: 4526241436)
        let sms = OutgoingSMS(message: "Hello world", sender: "Mustache", recipients: [recipient])
        return req.gateway.send(sms)
    }

}


