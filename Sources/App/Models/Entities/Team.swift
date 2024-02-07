//
//  Team.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Foundation
import Vapor
import Fluent

final class Team: Model, Content {
    static var schema: String = "team"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Parent(key: "userA_id")
    var userA: User

    @Parent(key: "userB_id")
    var userB: User

    
    init() {}
    
    init(id: Int? = nil, name: String, userA: Int, userB: Int) {
        self.id = id
        self.name = name
        self.$userA.id = userA
        self.$userB.id = userB
    }
}
