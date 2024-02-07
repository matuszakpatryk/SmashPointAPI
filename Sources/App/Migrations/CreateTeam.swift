import Fluent

struct CreateTeam: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("team")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("userA_id", .int, .references("user", "id"))
            .field("userB_id", .int, .references("user", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("team").delete()
    }
}
