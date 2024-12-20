//
//  RequestProtocol.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/27/24.
//

import Foundation

protocol RequestProtocol {
    var httpMethod: HTTPMethod { get }
    var url: URL? { get }
    func request() throws -> URLRequest
}
