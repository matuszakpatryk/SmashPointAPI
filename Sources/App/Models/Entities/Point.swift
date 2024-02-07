//
//  Point.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent

final class Point: Model, Content {
    static var schema: String = "point"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "pointNumber")
    var pointNumber: Int
    
    @Parent(key: "gem_id")
    var gem: Gem
    
    @OptionalParent(key: "team_id")
    var team: Team?
    
    init() {}
    
    init(id: Int? = nil, pointNumber: Int, gemID: Int, teamID: Int? = nil) {
        self.id = id
        self.pointNumber = pointNumber
        self.$gem.id = gemID
        self.$team.id = teamID
    }
}
