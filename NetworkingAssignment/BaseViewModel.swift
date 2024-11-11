//
//  BaseViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/12/24.
//

import Foundation

class BaseViewModel<T>: ObservableObject {
    typealias GHError = APIService.GHError
    
    @Published var result = Resource.loading
    
    let apiService = APIService()
    
    init() {
        refresh()
    }
    
    func getSuccessResult() async throws -> T? {
        nil
    }
    
    func refresh() {
        result = Resource.loading
        Task { @MainActor in
            do {
                if let successResult = try await getSuccessResult() {
                    result = Resource.success(successResult)
                }
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
        case success(T)
        case error(String)
    }
}
