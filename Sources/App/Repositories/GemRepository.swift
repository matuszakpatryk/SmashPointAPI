import Vapor
import Fluent

protocol GemRepository: Repository {
    func create(_ gem: Gem) -> EventLoopFuture<Void>
    func find(id: Int) throws -> EventLoopFuture<Gem?>
}

struct DatabaseGemRepository: GemRepository, DatabaseRepository {
    let database: Database
    
    func create(_ gem: Gem) -> EventLoopFuture<Void> {
        return gem.create(on: database)
    }
    
    func find(id: Int) throws -> EventLoopFuture<Gem?> {
        Gem.find(id, on: database)
    }
}

extension Application.Repositories {
    var gems: GemRepository {
        guard let storage = storage.makeGemRepository else {
            fatalError("TeamRepository not configured, use: app.teamRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (GemRepository)) {
        storage.makeGemRepository = make
    }
}
