import Vapor

struct AddGemRequest: Content {
    let set: Int
    let gemNumber: Int
}

extension AddGemRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("set", as: Int.self, is: .valid)
        validations.add("gemNumber", as: Int.self, is: .range(1...13))
    }
}

extension Gem {
    convenience init(from addGem: AddGemRequest) throws {
        self.init(gemNumber: addGem.gemNumber, setID: addGem.set)
    }
}
