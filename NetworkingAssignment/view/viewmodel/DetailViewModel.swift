//
//  DetailViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/27/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    let githubUser: GithubUser
    
    @Published var viewState: ViewState = .loading
    @Published var user: GithubUser?
    
    init(githubUser: GithubUser) {
        self.githubUser = githubUser
        refresh()
    }
    
    func refresh() {
        viewState = .loading
        Task { @MainActor in
            do {
                user = try await GithubUser.getUser(endPoint: Constants.endPoint + githubUser.login)
                self.viewState = .completed
            } catch {
                viewState = .failure(error: error)
            }
        }
    }
    
    private struct Constants {
        static let endPoint = "https://api.github.com/users/"
    }
}
