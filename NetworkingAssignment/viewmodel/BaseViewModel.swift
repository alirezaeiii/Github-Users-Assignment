//
//  BaseViewModel.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/12/24.
//

import Foundation

class BaseViewModel<T, R : Codable>: ObservableObject {
    @Published var result = Resource.loading
    
    let apiService = APIService<R>()
    
    enum Resource {
        case loading
        case success(T)
        case error(String)
    }
}
