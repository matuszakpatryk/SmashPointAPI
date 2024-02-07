import Vapor

struct AddMatchRequest: Content {
    let userA: Int
    let type: String
    let numberOfSets: Int
}

extension AddMatchRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("type", as: String.self, is: .case(of: MatchType.self))
        validations.add("numberOfSets", as: Int.self, is: .range(2...5))
    }
}

extension Match {
    convenience init(from addMatch: AddMatchRequest) throws {
        self.init(userA: addMatch.userA, type: addMatch.type, numberOfSets: addMatch.numberOfSets)
    }
}

enum MatchType: String, CaseIterable {
    case tennis
    case padel
    case badmington
}
