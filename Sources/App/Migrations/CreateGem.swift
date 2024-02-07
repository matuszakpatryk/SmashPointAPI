import Fluent

struct CreateGem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("gem")
            .field("id", .int, .identifier(auto: true))
            .field("set_id", .int, .references("set", "id"))
            .field("gemNumber", .int)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("gem").delete()
    }
}
