//
//  UserController.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("login", use: login)
                .openAPI(
                    summary: "Find pet by ID",
                    description: "Returns a single pet",
                    response: .type(LoginRequest.self),
                    responseContentType: .application(.json), .application(.xml)
                )
                .response(statusCode: .badRequest, description: "Invalid ID supplied")
                .response(statusCode: .notFound, description: "Pet not found")
            auth.post("register", use: register)
                .openAPI(
                    summary: "Find pet by ID",
                    description: "Returns a single pet",
                    response: .type(LoginRequest.self),
                    responseContentType: .application(.json), .application(.xml)
                )
                .response(statusCode: .badRequest, description: "Invalid ID supplied")
                .response(statusCode: .notFound, description: "Pet not found")
            auth.post("accessToken", use: refreshAccessToken)
                .openAPI(
                    summary: "Find pet by ID",
                    description: "Returns a single pet",
                    response: .type(LoginRequest.self),
                    responseContentType: .application(.json), .application(.xml)
                )
                .response(statusCode: .badRequest, description: "Invalid ID supplied")
                .response(statusCode: .notFound, description: "Pet not found")
        }
    }
    
    private func login(_ req: Request) throws -> EventLoopFuture<LoginResponse> {
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        return req.users
            .find(email: loginRequest.email)
            .unwrap(or: AuthenticationError.invalidEmailOrPassword)
            .flatMap { user -> EventLoopFuture<User> in
                return req.password
                    .async
                    .verify(loginRequest.password, created: user.password)
                    .guard({ $0 == true }, else: AuthenticationError.invalidEmailOrPassword)
                        .transform(to: user)
            }
            .flatMap { user -> EventLoopFuture<User> in
                do {
                    return try req.refreshTokens.delete(for: user.requireID()).transform(to: user)
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            }
            .flatMap { user in
                do {
                    let userToken = randomizeToken
                    let refreshToken = try RefreshToken(token: SHA256.hash(userToken), userID: user.requireID())
                    print("Refresh: \(refreshToken)")
                    print("Token: \(userToken)")
                    return req.refreshTokens
                        .create(refreshToken)
                        .flatMapThrowing {
                            return try LoginResponse(
                                user: user,
                                accessToken: req.jwt.sign(Payload(with: user)),
                                refreshToken: userToken
                            )
                        }
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
            }
    }
    
    private func register(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try RegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(RegisterRequest.self)
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        return req.password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing { digest in
                try User(from: registerRequest, password: digest)
            }
            .flatMap { user in
                req.users
                    .create(user)
                    .flatMapErrorThrowing {
                        if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                            throw AuthenticationError.emailAlreadyExists
                        }
                        throw $0
                    }
                    .flatMap { req.eventLoop.future() }
            }
            .transform(to: .created)
    }
    
    private func refreshAccessToken(_ req: Request) throws -> EventLoopFuture<AccessTokenResponse> {
        let accessTokenRequest = try req.content.decode(AccessTokenRequest.self)
        let hashedRefreshToken = SHA256.hash(accessTokenRequest.refreshToken)
        
        return req.refreshTokens
            .find(token: hashedRefreshToken)
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { req.refreshTokens.delete($0).transform(to: $0) }
            .guard({ $0.expiresAt > Date() }, else: AuthenticationError.refreshTokenHasExpired)
            .flatMap { req.users.find(id: $0.$user.id) }
            .unwrap(or: AuthenticationError.refreshTokenOrUserNotFound)
            .flatMap { user in
                do {
                    let userToken = randomizeToken
                    let refreshToken = try RefreshToken(token: SHA256.hash(userToken), userID: user.requireID())
                    
                    let payload = try Payload(with: user)
                    let accessToken = try req.jwt.sign(payload)
                    
                    return req.refreshTokens
                        .create(refreshToken)
                        .transform(to: (userToken, accessToken))
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
        }
        .map { AccessTokenResponse(refreshToken: $0, accessToken: $1) }
    }
    
    private var randomizeToken: String {
        [UInt8].random(count: 256 / 8).hex
    }
}
