//
//  RefreshToken.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor
import Fluent

final class RefreshToken: Model {
    static let schema = "user_refresh_tokens"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "token")
    var token: String
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "expires_at")
    var expiresAt: Date
    
    @Field(key: "issued_at")
    var issuedAt: Date
    
    init() {}
    
    init(
        id: Int? = nil,
        token: String,
        userID: Int,
        expiresAt: Date = Date().addingTimeInterval(Constants.REFRESH_TOKEN_LIFETIME),
        issuedAt: Date = Date()
    ) {
        self.id = id
        self.token = token
        self.$user.id = userID
        self.expiresAt = expiresAt
        self.issuedAt = issuedAt
    }
}

