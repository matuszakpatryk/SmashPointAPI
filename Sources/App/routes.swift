import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.group("api") { api in
        try! api.register(collection: UserController())
    }
}
