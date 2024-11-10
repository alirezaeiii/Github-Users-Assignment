//
//  User.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/10/24.
//

import Foundation

struct UserWrapper: Identifiable {
    let section: String
    let users: [GithubUser]
    let id: UUID
    
    static func createUsers(following: [GithubUser], followers: [GithubUser]) -> [UserWrapper] {
        var items = Array<UserWrapper>()
        items.append(UserWrapper(section: "Following", users: following, id: UUID()))
        items.append(UserWrapper(section: "Followers", users: followers, id: UUID()))
        return items
    }
}
