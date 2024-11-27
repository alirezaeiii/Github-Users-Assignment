//
//  ContentView.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: GithubViewModel
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridItemSize))]) {
                        ForEach(viewModel.users) { userWrapper in
                            Section(userWrapper.section) {
                                ForEach(userWrapper.users, id: \.self.login) { user in
                                    NavigationLink(value: user)  {
                                        UserColumn(user: user)
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
        } onRetry: {
            viewModel.refresh()
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
