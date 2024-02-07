//
//  Set.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent

final class Set: Model, Content {
    static var schema: String = "set"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "setNumber")
    var setNumber: Int
    
    @Parent(key: "match_id")
    var match: Match
    
    init() {}
    
    init(id: Int? = nil, setNumber: Int, matchID: Int) {
        self.id = id
        self.setNumber = setNumber
        self.$match.id = matchID
    }
}
