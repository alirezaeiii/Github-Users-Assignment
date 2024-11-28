//
//  DetailViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/27/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    private let networkService: NetworkServiceProtocol
    private let githubUser: GithubUser
    
    @Published var viewState: ViewState = .loading
    @Published var user: GithubUser?
    
    init(networkService: NetworkServiceProtocol, githubUser: GithubUser) {
        self.networkService = networkService
        self.githubUser = githubUser
        refresh()
    }
    
    func refresh() {
        viewState = .loading
        let request = GithubRequest(path: .user(login: githubUser.login))
        Task { @MainActor in
            do {
                user = try await networkService.perform(request: request)
                self.viewState = .completed
            } catch {
                viewState = .failure(error: error)
            }
        }
    }
}
