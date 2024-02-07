//
//  GemController.swift
//  
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct GemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("gem") { auth in
            auth.post("add", use: addGem)
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
    
    private func addGem(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try AddGemRequest.validate(content: req)
        let addGemRequest = try req.content.decode(AddGemRequest.self)
        
        
        let gem = try Gem(from: addGemRequest)
        
        return req.gems
            .create(gem)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    throw ProductError.productNameAlreadyExist
                }
                
                throw $0
            }
            .flatMap { req.eventLoop.future(.created) }
    }
}
