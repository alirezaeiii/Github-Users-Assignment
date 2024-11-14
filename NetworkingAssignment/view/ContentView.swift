//
//  ContentView.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/9/24.
//

import SwiftUI

struct ContentView: View {
    typealias Resource = GithubViewModel.Resource
    
    @ObservedObject var viewModel: GithubViewModel
    
    var body: some View {
        switch viewModel.result {
        case Resource.loading : ProgressView()
        case Resource.error(let message):
            VStack {
                Text(message)
                    .padding(.vertical)
                Button("Retry") {
                    viewModel.refresh()
                }
            }
        case Resource.success(let userWrappers):
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridItemSize))]) {
                        ForEach(userWrappers) { userWrapper in
                            Section(userWrapper.section) {
                                ForEach(userWrapper.users, id: \.self.login) { user in
                                    NavigationLink(value: user)  {
                                        UserItemView(user: user)
                                    }
                                }
                            }
                        }
                    }.navigationDestination(for: GithubUser.self) { user in
                        DetailView(user: user)
                    }
                    .navigationTitle("List")
                }
            }
        }
    }
    
    private struct Constants {
        static let gridItemSize: Double = 180
    }
}

#Preview {
    let viewModel = GithubViewModel()
    return ContentView(viewModel: viewModel)
}
