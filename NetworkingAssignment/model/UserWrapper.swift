//
//  User.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/10/24.
//

import Foundation

struct UserWrapper {
    let section: String
    let users: [GithubUser]
    let id: UUID
}

extension UserWrapper {
    static func createUsers(following: [GithubUser], followers: [GithubUser]) -> [UserWrapper] {
        var items = Array<UserWrapper>()
        items.append(UserWrapper(section: "Following", users: following, id: UUID()))
        items.append(UserWrapper(section: "Followers", users: followers, id: UUID()))
        return items
    }
}

// Ensure that the model's conformance to Identifiable is public.
extension UserWrapper : Identifiable {}
