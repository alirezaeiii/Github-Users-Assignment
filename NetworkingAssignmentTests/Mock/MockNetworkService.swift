//
//  MockNetworkService.swift
//  CachingSwiftDataTests
//
//  Created by Ali on 12/16/24.
//

import Foundation
@testable import NetworkingAssignment

final class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func perform(request: RequestProtocol) async throws -> Data {
        if let error = mockError {
            throw error
        }
        guard let data = mockData else {
            throw NSError(domain: "MockNetworkServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No mock data provided"])
        }
        return data
    }
    
    func perform<T: Decodable>(request: RequestProtocol) async throws -> T {
        let data = try await perform(request: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
