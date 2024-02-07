import Foundation
import Vapor
import VaporToOpenAPI

struct OpenAPIController: RouteCollection {

    // MARK: Internal

    func boot(routes: RoutesBuilder) throws {

        // generate OpenAPI documentation
        routes.get("Swagger", "swagger.json") { req in
            req.application.routes.openAPI(
                info: InfoObject(
                    title: "Smash Point swagger",
                    description: "Smash point API Swagger for Mareczek",
                    version: Version(0, 0, 1)
                )
            )
        }
        .excludeFromOpenAPI()
    }
}
