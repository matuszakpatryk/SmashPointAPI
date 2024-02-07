//
//  User.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Foundation
import Vapor
import Fluent

final class User: Model, Content {
    static var schema: String = "user"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String

    
    init() {}
    
    init(id: Int? = nil, name: String, email: String, password: String) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
    }
}
