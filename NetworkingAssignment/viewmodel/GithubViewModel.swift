//
//  SubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/11/24.
//

import Foundation

class GithubViewModel : BaseViewModel<[UserWrapper], [GithubUser]> {
    
    override init() {
        super.init()
        refresh()
    }
    
    func refresh() {
        result = Resource.loading
        Task { @MainActor in
            async let following = apiService.getDataFromRemote(endPoint: Constants.followingEndPoint)
            async let followers = apiService.getDataFromRemote(endPoint: Constants.followersEndPoint)
            do {
                let (fetchedFollowing, fetchedFollowers) = try await (following, followers)
                result = Resource.success(UserWrapper.createUsers(following: fetchedFollowing, followers: fetchedFollowers))
            } catch GHError.invalidURL {
                result = Resource.error("Invalid URL")
            } catch GHError.invalidResponse {
                result = Resource.error("Invalid response")
            } catch GHError.invalidData {
                result = Resource.error("Invalid data")
            } catch {
                result = Resource.error("Unexpected error")
            }
        }
    }
    
    private struct Constants {
        private static let endPoint = "https://api.github.com/users/alirezaeiii/"
        static let followingEndPoint = endPoint + "following"
        static let followersEndPoint = endPoint + "followers"
    }
}
