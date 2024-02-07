import Fluent

struct CreateSet: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("set")
            .field("id", .int, .identifier(auto: true))
            .field("match_id", .int, .references("match", "id"))
            .field("setNumber", .int)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("set").delete()
    }
}
