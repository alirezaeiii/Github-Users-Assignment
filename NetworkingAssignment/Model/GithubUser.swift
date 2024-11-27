//
//  GithubUser.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/10/24.
//

import Foundation

struct GithubUser: Decodable, Hashable {
    let login: String
    let avatarUrl: String
    let bio: String?
}
