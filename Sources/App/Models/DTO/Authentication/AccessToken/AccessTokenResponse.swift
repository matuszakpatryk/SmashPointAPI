//
//  AccessTokenResponse.swift
//  
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

struct AccessTokenResponse: Content {
    let refreshToken: String
    let accessToken: String
}
