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
        Task {
            do {
                result = try await Resource.success(apiService.getUser())
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
    
    enum Resource {
        case loading
        case success(GithubUser)
        case error(String)
    }
}
