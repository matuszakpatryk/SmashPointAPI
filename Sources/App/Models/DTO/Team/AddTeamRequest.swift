import Vapor

struct AddTeamRequest: Content {
    let name: String
    let userA: Int
    let userB: Int
}

extension AddTeamRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(2...))
    }
}

extension Team {
    convenience init(from addTeam: AddTeamRequest) throws {
        self.init(name: addTeam.name, userA: addTeam.userA, userB: addTeam.userB)
    }
}
