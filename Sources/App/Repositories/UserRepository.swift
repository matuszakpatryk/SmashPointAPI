//
//  UserRepository.swift
//  
//
//  Created by Patryk on 18/01/2024.
//

import Vapor
import Fluent

protocol UserRepository: Repository {
    func create(_ user: User) -> EventLoopFuture<Void>
    func delete(id: Int) -> EventLoopFuture<Void>
    func all() -> EventLoopFuture<[User]>
    func find(id: Int?) -> EventLoopFuture<User?>
    func find(email: String) -> EventLoopFuture<User?>
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    let database: Database
    
    func create(_ user: User) -> EventLoopFuture<Void> {
        return user.create(on: database)
    }
    
    func delete(id: Int) -> EventLoopFuture<Void> {
        return User.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func all() -> EventLoopFuture<[User]> {
        return User.query(on: database).all()
    }
    
    func find(id: Int?) -> EventLoopFuture<User?> {
        return User.find(id, on: database)
    }
    
    func find(email: String) -> EventLoopFuture<User?> {
        return User.query(on: database)
            .filter(\.$email == email)
            .first()
    }
}

extension Application.Repositories {
    var users: UserRepository {
        guard let storage = storage.makeUserRepository else {
            fatalError("UserRepository not configured, use: app.userRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (UserRepository)) {
        storage.makeUserRepository = make
    }
}
