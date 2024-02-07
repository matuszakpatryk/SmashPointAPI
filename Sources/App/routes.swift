import Vapor

func routes(_ app: Application) throws {
    app.group("api") { api in
        try! api.register(collection: UserController())
        try! api.register(collection: TeamController())
        try! api.register(collection: MatchController())
        try! api.register(collection: SetController())
        try! api.register(collection: GemController())
        try! api.register(collection: PointController())
        try! api.register(collection: OpenAPIController())
    }
}
