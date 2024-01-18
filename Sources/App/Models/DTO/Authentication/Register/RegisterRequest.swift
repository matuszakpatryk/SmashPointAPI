//
//  RegisterRequest.swift
//
//
//  Created by Patryk on 18/01/2024.
//

import Vapor

struct RegisterRequest: Content {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

extension RegisterRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .count(3...))
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    convenience init(from register: RegisterRequest, password: String) throws {
        self.init(name: register.name, email: register.email, password: password)
    }
}
