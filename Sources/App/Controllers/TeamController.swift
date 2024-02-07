//
//  TeamController.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct TeamController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("team") { auth in
            auth.post("add", use: addTeam)
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
    
    private func addTeam(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try AddTeamRequest.validate(content: req)
        let addTeamRequest = try req.content.decode(AddTeamRequest.self)
        
        
        let team = try Team(from: addTeamRequest)
        
        return req.teams
            .create(team)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    throw ProductError.productNameAlreadyExist
                }
                
                throw $0
            }
            .flatMap { req.eventLoop.future(.created) }
    }
}
