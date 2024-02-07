import Vapor

func migrations(_ app: Application) throws {
    // Initial Migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateRefreshToken())
    app.migrations.add(CreateTeam())
    app.migrations.add(CreateMatch())
    app.migrations.add(CreateSet())
    app.migrations.add(CreateGem())
    app.migrations.add(CreatePoint())
}
