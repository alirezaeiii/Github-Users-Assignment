//
//  SubViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/11/24.
//

import Foundation
import OSLog

class MainViewModel : ObservableObject {
    private let networkService: NetworkServiceProtocol
    
    @Published var viewState: ViewState = .loading
    @Published var users: [UserWrapper] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        refresh()
    }
    
    func refresh() {
        viewState = .loading
        let followingRequest = GithubRequest(path: .following)
        let followersRequest = GithubRequest(path: .followers)
        Task { @MainActor in
            async let following: [GithubUser] = networkService.perform(request: followingRequest)
            async let followers: [GithubUser] = networkService.perform(request: followersRequest)
            do {
                let (fetchedFollowing, fetchedFollowers) = try await (following, followers)
                users = UserWrapper.createUsers(following: fetchedFollowing, followers: fetchedFollowers)
                self.viewState = .completed
            } catch {
                viewState = .failure(error: error)
            }
        }
    }

}
