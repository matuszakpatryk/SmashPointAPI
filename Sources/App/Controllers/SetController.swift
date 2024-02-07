//
//  SetController.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct SetController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("set") { auth in
            auth.post("add", use: addSet)
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
    
    private func addSet(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try AddSetRequest.validate(content: req)
        let addSetRequest = try req.content.decode(AddSetRequest.self)
        
        
        let set = try Set(from: addSetRequest)
        
        return req.sets
            .create(set)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    throw ProductError.productNameAlreadyExist
                }
                
                throw $0
            }
            .flatMap { req.eventLoop.future(.created) }
    }
}
