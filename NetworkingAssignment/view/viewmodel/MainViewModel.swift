//
//  SubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/11/24.
//

import Foundation
import OSLog

class MainViewModel : ObservableObject {
    
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
                let (fetchedFollowing, fetchedFollowers) = try await (following, followers)
                users = UserWrapper.createUsers(following: fetchedFollowing, followers: fetchedFollowers)
                self.viewState = .completed
            } catch {
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
