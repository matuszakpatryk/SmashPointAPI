import Vapor
import Fluent

protocol PointRepository: Repository {
    func create(_ point: Point) -> EventLoopFuture<Void>
    func find(id: Int) throws -> EventLoopFuture<Point?>
}

struct DatabasePointRepository: PointRepository, DatabaseRepository {
    let database: Database
    
    func create(_ point: Point) -> EventLoopFuture<Void> {
        return point.create(on: database)
    }
    
    func find(id: Int) throws -> EventLoopFuture<Point?> {
        Point.find(id, on: database)
    }
}

extension Application.Repositories {
    var points: PointRepository {
        guard let storage = storage.makePointRepository else {
            fatalError("TeamRepository not configured, use: app.teamRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (PointRepository)) {
        storage.makePointRepository = make
    }
}
