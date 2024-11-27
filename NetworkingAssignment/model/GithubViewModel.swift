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
    
    @Published var viewState: ViewState = .loading
    @Published var users: [UserWrapper] = []
    
    init() {
        refresh()
    }
    
    func refresh() {
        viewState = .loading
        Task { @MainActor in
            async let following = GithubUser.getUsers(endPoint: Constants.followingEndPoint)
            async let followers = GithubUser.getUsers(endPoint: Constants.followersEndPoint)
            do {
                logger.debug("Refreshing the data ...")
                let (fetchedFollowing, fetchedFollowers) = try await (following, followers)
                users = UserWrapper.createUsers(following: fetchedFollowing, followers: fetchedFollowers)
                logger.debug("Refresh complete.")
                self.viewState = .completed
            } catch {
                logger.error("\(error.localizedDescription)")
                viewState = .failure(error: error)
            }
        }
    }
    
    private struct Constants {
        private static let endPoint = "https://api.github.com/users/alirezaeiii/"
        static let followingEndPoint = endPoint + "following"
        static let followersEndPoint = endPoint + "followers"
    }
}
