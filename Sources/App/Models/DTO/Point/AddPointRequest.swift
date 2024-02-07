import Vapor

struct AddPointRequest: Content {
    let gem: Int
    let team: Int?
    let pointNumber: Int
}

extension AddPointRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("gem", as: Int.self, is: .valid)
        validations.add("pointNumber", as: Int.self, is: .range(1...13))
    }
}

extension Point {
    convenience init(from addPoint: AddPointRequest) throws {
        self.init(pointNumber: addPoint.pointNumber, gemID: addPoint.gem, teamID: addPoint.team)
    }
}
