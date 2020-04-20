import Vapor

public struct OutgoingSMS: Content {
    
    let message: String
    let sender: String
    let recipients: [Recipient]

    public init(message: String, sender: String, recipients: [Recipient]) {
        self.message = message
        self.sender = sender
        self.recipients = recipients
    }
}

public struct Recipient: Content {
    var msisdn: Int
    
    public init(msisdn: Int) {
        self.msisdn = msisdn
    }
}
