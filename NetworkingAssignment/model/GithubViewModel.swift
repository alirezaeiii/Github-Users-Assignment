//
//  SubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/11/24.
//

import Foundation
import OSLog

class GithubViewModel : ObservableObject {
    
    /// A logger for debugging.
        fileprivate let logger = Logger(subsystem: "com.sample.NetworkingAssignment", category: "parsing")
    
    @Published var result = Resource.loading
    
    init() {
        refresh()
    }
    
    func refresh() {
        result = Resource.loading
        Task { @MainActor in
            async let following = GithubUser.getUsers(endPoint: Constants.followingEndPoint)
            async let followers = GithubUser.getUsers(endPoint: Constants.followersEndPoint)
            do {
                logger.debug("Refreshing the data ...")
                let (fetchedFollowing, fetchedFollowers) = try await (following, followers)
                result = Resource.success(UserWrapper.createUsers(following: fetchedFollowing, followers: fetchedFollowers))
                logger.debug("Refresh complete.")
            } catch {
                logger.error("\(error.localizedDescription)")
                result = Resource.error("Something went wrong")
            }
        }
    }
    
    private struct Constants {
        private static let endPoint = "https://api.github.com/users/alirezaeiii/"
        static let followingEndPoint = endPoint + "following"
        static let followersEndPoint = endPoint + "followers"
    }
    
    enum Resource {
        case loading
        case success([UserWrapper])
        case error(String)
    }
}
