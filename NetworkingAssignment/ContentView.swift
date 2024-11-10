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
                Button("Refresh") {
                    viewModel.refresh()
                }
            }
        case Resource.success(let users):
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridSize))]) {
                    ForEach(users, id: \.self.login) { user in
                        VStack {
                            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                                image
                                    .frame(width: Constants.radius, height: Constants.radius)
                                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                    .foregroundColor(.secondary)
                                    .frame(width: Constants.radius, height: Constants.radius)
                            }
                            Text(user.login)
                                .font(.title3)
                        }.padding()
                    }
                }
            }
        }
    }
    
    private struct Constants {
        static let gridSize: Double = 180
        static let cornerRadius: Double = 10
        static let radius: Double = 160
    }
}

#Preview {
    let viewModel = GithubViewModel()
    return ContentView(viewModel: viewModel)
}
