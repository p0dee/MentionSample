//
//  UserRepository.swift
//  MentionSample
//
//  Created by p0dee on 2021/05/13.
//

import Foundation

class UserRepository {
    
    static let shared = UserRepository()
    
    private var dummyUsers: [User] = [
        .init(id: "abcde", name: "たろう"),
        .init(id: "fghij", name: "はなこ"),
        .init(id: "klmno", name: "じろう"),
        .init(id: "pqrst", name: "さぶろう"),
        .init(id: "uvwxyz", name: "ごろう")
    ]
    
    func all() -> [User] {
        return dummyUsers
    }
    
    func find(byID id: String) -> User? {
        return dummyUsers.first { $0.id == id }
    }
    
}
