//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

extension Request {
    var users: UserRepository { application.repositories.users.for(self) }
    var teams: TeamRepository { application.repositories.teams.for(self) }
    var matches: MatchRepository { application.repositories.matches.for(self) }
    var sets: SetRepository { application.repositories.sets.for(self) }
    var gems: GemRepository { application.repositories.gems.for(self) }
    var points: PointRepository { application.repositories.points.for(self) }
    var refreshTokens: RefreshTokenRepository { application.repositories.refreshTokens.for(self) }
}
