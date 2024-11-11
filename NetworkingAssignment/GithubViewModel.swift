//
//  SubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/11/24.
//

import Foundation

class GithubViewModel : BaseViewModel<[UserWrapper], [GithubUser]> {
    
    override func getSuccessResult() async throws -> [UserWrapper] {
        async let following = apiService.getDataFromRemote(endPoint: Constants.followingEndPoint)
        async let followers = apiService.getDataFromRemote(endPoint: Constants.followersEndPoint)
        return try await UserWrapper.createUsers(following: following, followers: followers)
    }
    
    private struct Constants {
        private static let endPoint = "https://api.github.com/users/alirezaeiii/"
        static let followingEndPoint = endPoint + "following"
        static let followersEndPoint = endPoint + "followers"
    }
}
