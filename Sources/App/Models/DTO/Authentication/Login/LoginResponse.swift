//
//  LoginResponse.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

struct LoginResponse: Content {
    let user: User
    let accessToken: String
    let refreshToken: String
    
    init(user: User, accessToken: String, refreshToken: String) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        
        print("Init: token: \(self.refreshToken)")
    }
}
