//
//  GithubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/10/24.
//

import Foundation

class GithubViewModel: ObservableObject {
    typealias GHError = APIService.GHError
    
    @Published var result = Resource.loading
    
    private let apiService = APIService()
    
    init() {
        refresh()
    }
    
    func refresh() {
        result = Resource.loading
        Task { @MainActor in
            async let following = apiService.getUsers(endPoint: Constants.followingEndPoint)
            async let followers = apiService.getUsers(endPoint: Constants.followersEndPoint)
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
        static let endPoint = "https://api.github.com/users/alirezaeiii/"
        static let followingEndPoint = endPoint + "following"
        static let followersEndPoint = endPoint + "followers"
    }
    
    enum Resource {
        case loading
        case success([UserWrapper])
        case error(String)
    }
}
