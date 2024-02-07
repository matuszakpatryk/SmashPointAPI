import Vapor
import Fluent

protocol TeamRepository: Repository {
    func create(_ team: Team) -> EventLoopFuture<Void>
    func find(id: Int) throws -> EventLoopFuture<Team?>
}

struct DatabaseTeamRepository: TeamRepository, DatabaseRepository {
    let database: Database
    
    func create(_ team: Team) -> EventLoopFuture<Void> {
        return team.create(on: database)
    }
    
    func find(id: Int) throws -> EventLoopFuture<Team?> {
        return Team.find(id, on: database)
    }
}

extension Application.Repositories {
    var teams: TeamRepository {
        guard let storage = storage.makeTeamRepository else {
            fatalError("TeamRepository not configured, use: app.teamRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (TeamRepository)) {
        storage.makeTeamRepository = make
    }
}



