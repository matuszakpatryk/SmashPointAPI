import Fluent

struct CreateMatch: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("match")
            .field("id", .int, .identifier(auto: true))
            .field("userA_id", .int, .references("user", "id"))
            .field("userB_id", .int, .references("user", "id"))
            .field("type", .string)
            .field("numberOfSets", .int)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("match").delete()
    }
}
