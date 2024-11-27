//
//  GithubRequest.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/27/24.
//

import Foundation

struct GithubRequest: RequestProtocol {
    let endpoint: Endpoint
    let httpMethod: HTTPMethod = .GET
    let url: URL?
    
    init(path: GithubEndpoint.Paths) {
        self.endpoint = GithubEndpoint.github(path: path)
        self.url = DefaultURLFactory.createURL(from: endpoint)
    }

    func request() throws -> URLRequest {
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        return request
    }
}
