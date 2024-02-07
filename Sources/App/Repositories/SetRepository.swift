import Vapor
import Fluent

protocol SetRepository: Repository {
    func create(_ set: Set) -> EventLoopFuture<Void>
    func find(id: Int) throws -> EventLoopFuture<Set?>
}

struct DatabaseSetRepository: SetRepository, DatabaseRepository {
    let database: Database
    
    func create(_ set: Set) -> EventLoopFuture<Void> {
        return set.create(on: database)
    }
    
    func find(id: Int) throws -> EventLoopFuture<Set?> {
        Set.find(id, on: database)
    }
}

extension Application.Repositories {
    var sets: SetRepository {
        guard let storage = storage.makeSetRepository else {
            fatalError("TeamRepository not configured, use: app.teamRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (SetRepository)) {
        storage.makeSetRepository = make
    }
}
