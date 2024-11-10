//
//  NetworkingAssignmentApp.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/9/24.
//

import SwiftUI

@main
struct NetworkingAssignmentApp: App {
    let viewModel = GithubViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
