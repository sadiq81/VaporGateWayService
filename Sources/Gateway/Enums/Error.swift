public enum GatewayError: Error {
    
    case encodingProblem
    case invalidArguments(reason: String)
    case invalidAPIKeyOrSignature
    case unauthorizedIpAddress
    case invalidJsonRequestBody
    case internalServerEror(reason: String)

}
