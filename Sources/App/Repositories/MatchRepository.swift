import Vapor
import Fluent

protocol MatchRepository: Repository {
    func create(_ match: Match) -> EventLoopFuture<Void>
    func find(userID: Int) throws -> EventLoopFuture<[Match]>
}

struct DatabaseMatchRepository: MatchRepository, DatabaseRepository {
    let database: Database
    
    func create(_ match: Match) -> EventLoopFuture<Void> {
        return match.create(on: database)
    }
    
    func find(userID: Int) throws -> EventLoopFuture<[Match]> {
        let userMatches = Match.query(on: database)
            .join(User.self, on: \Match.$userA.$id == \User.$id)
            .join(User.self, on: \Match.$userB.$id == \User.$id)
            .group(.or) { group in
                group
                    .filter(User.self, \.$id == userID)
            }.all()
        
        return userMatches
    }
}

extension Application.Repositories {
    var matches: MatchRepository {
        guard let storage = storage.makeMatchRepository else {
            fatalError("TeamRepository not configured, use: app.teamRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (MatchRepository)) {
        storage.makeMatchRepository = make
    }
}
