//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

extension Request {
    var users: UserRepository { application.repositories.users.for(self) }
    var refreshTokens: RefreshTokenRepository { application.repositories.refreshTokens.for(self) }
}
