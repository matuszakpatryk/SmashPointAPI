//
//  Match.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent

final class Match: Model, Content {
    static var schema: String = "match"
    
    @ID(custom: "id")
    var id: Int?
    
    @Parent(key: "userA_id")
    var userA: User

    @OptionalParent(key: "userB_id")
    var userB: User?
    
    @Field(key: "type") 
    var type: String
    
    @Field(key: "numberOfSets")
    var numberOfSets: Int
    
    init() {}
    
    init(id: Int? = nil, userA: Int, userB: Int? = nil, type: String, numberOfSets: Int) {
        self.id = id
        self.$userA.id = userA
        self.$userB.id = userB
        self.type = type
        self.numberOfSets = numberOfSets
    }
}
