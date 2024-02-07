//
//  MatchController.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct MatchController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("match") { auth in
            auth.post("add", use: addMatch)
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
    
    private func addMatch(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try AddMatchRequest.validate(content: req)
        let addMatchRequest = try req.content.decode(AddMatchRequest.self)
        
        
        let match = try Match(from: addMatchRequest)
        
        return req.matches
            .create(match)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    throw ProductError.productNameAlreadyExist
                }
                
                throw $0
            }
            .flatMap { req.eventLoop.future(.created) }
    }
}
