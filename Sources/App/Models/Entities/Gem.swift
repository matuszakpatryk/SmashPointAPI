//
//  Gem.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent

final class Gem: Model, Content {
    static var schema: String = "gem"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "gemNumber")
    var gemNumber: Int
    
    @Parent(key: "set_id")
    var set: Set
    
    init() {}
    
    init(id: Int? = nil, gemNumber: Int, setID: Int) {
        self.id = id
        self.gemNumber = gemNumber
        self.$set.id = setID
    }
}
