//
//  NetworkingAssignmentApp.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/9/24.
//

import SwiftUI

enum NavigationPath: Hashable {
    case list
    case detail(user: GithubUser)
}

@main
struct NetworkingAssignmentApp: App {
    
    @State private var navigationPaths = [NavigationPath]()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPaths) {
                ContentView(viewModel: MainViewModel(), navigationPath: $navigationPaths)
                    .navigationDestination(for: NavigationPath.self) { path in
                        switch path {
                        case .list:
                            ContentView(viewModel: MainViewModel(), navigationPath: $navigationPaths)
                        case .detail(user:  let user):
                            DetailView(viewModel: DetailViewModel(githubUser: user))
                        }
                        
                    }
            }
        }
    }
}
