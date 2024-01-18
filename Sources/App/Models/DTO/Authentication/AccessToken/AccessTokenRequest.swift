//
//  AccessTokenRequest.swift
//  
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

struct AccessTokenRequest: Content {
    let refreshToken: String
}
