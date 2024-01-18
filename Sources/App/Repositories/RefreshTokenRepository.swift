//
//  RefreshTokenRepository.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor
import Fluent

protocol RefreshTokenRepository: Repository {
    func create(_ token: RefreshToken) -> EventLoopFuture<Void>
    func find(id: Int?) -> EventLoopFuture<RefreshToken?>
    func find(token: String) -> EventLoopFuture<RefreshToken?>
    func delete(_ token: RefreshToken) -> EventLoopFuture<Void>
    func delete(for userID: Int) -> EventLoopFuture<Void>
}

struct DatabaseRefreshTokenRepository: RefreshTokenRepository, DatabaseRepository {
    let database: Database
    
    func create(_ token: RefreshToken) -> EventLoopFuture<Void> {
        return token.create(on: database)
    }
    
    func find(id: Int?) -> EventLoopFuture<RefreshToken?> {
        return RefreshToken.find(id, on: database)
    }
    
    func find(token: String) -> EventLoopFuture<RefreshToken?> {
        return RefreshToken.query(on: database)
            .filter(\.$token == token)
            .first()
    }
    
    func delete(_ token: RefreshToken) -> EventLoopFuture<Void> {
        token.delete(on: database)
    }
    
    func delete(for userID: Int) -> EventLoopFuture<Void> {
        RefreshToken.query(on: database)
            .filter(\.$user.$id == userID)
            .delete()
    }
}

extension Application.Repositories {
    var refreshTokens: RefreshTokenRepository {
        guard let factory = storage.makeRefreshTokenRepository else {
            fatalError("RefreshToken repository not configured, use: app.repositories.use")
        }
        return factory(app)
    }
    
    func use(_ make: @escaping (Application) -> (RefreshTokenRepository)) {
        storage.makeRefreshTokenRepository = make
    }
}
