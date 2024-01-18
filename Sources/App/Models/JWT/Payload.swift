import Vapor
import JWT

struct Payload: JWTPayload, Authenticatable {
    // User-releated stuff
    var userID: Int
    var name: String
    var email: String
    
    // JWT stuff
    var exp: ExpirationClaim
    
    func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }
    
    init(with user: User) throws {
        self.userID = try user.requireID()
        self.name = user.name
        self.email = user.email
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.ACCESS_TOKEN_LIFETIME))
    }
}

extension User {
    convenience init(from payload: Payload) {
        self.init(id: payload.userID, name: payload.name, email: payload.email, password: "")
    }
}
