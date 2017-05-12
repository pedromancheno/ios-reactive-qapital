//
//  User.swift
//  ReactiveQapital
//
//  Created by Mikael Gransell on 2017-04-29.
//  Copyright © 2017 Qapital Inc. All rights reserved.
//

import Foundation
import Curry
import Runes
import Argo

struct User {
    let id: Int
    let displayName: String
    let avatarURL: URL
    let enabled: Bool
}

extension User: Decodable {
    static func decode(_ json: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> json <| "userId"
            <*> json <| "displayName"
            <*> (json <| "avatarUrl").flatMap { Decoded<URL>.fromOptional(URL(string: $0)) }
            <*> json <| "enabled"
    }
}

extension User {
    func toJSON() -> [String: Any] {
        return ["userId": id,
                "displayName": displayName,
                "avatarUrl": avatarURL.absoluteString,
                "enabled": enabled]
    }
}
