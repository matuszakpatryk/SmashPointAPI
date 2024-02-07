import Fluent

struct CreatePoint: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("point")
            .field("id", .int, .identifier(auto: true))
            .field("gem_id", .int, .references("gem", "id"))
            .field("team_id", .int, .references("team", "id"))
            .field("pointNumber", .int)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("point").delete()
    }
}
