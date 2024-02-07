import Vapor

struct AddSetRequest: Content {
    let match: Int
    let setNumber: Int
}

extension AddSetRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("match", as: Int.self, is: .valid)
        validations.add("setNumber", as: Int.self, is: .range(1...5))
    }
}

extension Set {
    convenience init(from addSet: AddSetRequest) throws {
        self.init(setNumber: addSet.setNumber, matchID: addSet.match)
    }
}
