//
//  PointController.swift
//
//
//  Created by Patryk on 19/01/2024.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct PointController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("point") { auth in
            auth.post("add", use: addPoint)
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
    
    private func addPoint(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try AddPointRequest.validate(content: req)
        let addPointRequest = try req.content.decode(AddPointRequest.self)
        
        
        let point = try Point(from: addPointRequest)
        
        return req.points
            .create(point)
            .flatMapErrorThrowing {
                if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                    throw ProductError.productNameAlreadyExist
                }
                
                throw $0
            }
            .flatMap { req.eventLoop.future(.created) }
    }
}
