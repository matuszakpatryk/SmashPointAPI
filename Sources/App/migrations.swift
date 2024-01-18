import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
     app.migrations.add(CreateUser())
     app.migrations.add(CreateRefreshToken())
}
