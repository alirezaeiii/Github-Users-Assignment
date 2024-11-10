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
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridItemSize))]) {
                        ForEach(users, id: \.self.login) { user in
                            NavigationLink(value: user)  {
                                VStack {
                                    AsyncImage(url: URL(string: user.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: Constants.frameSize, height: Constants.frameSize)
                                            .clipShape(shape)
                                    } placeholder: {
                                        shape.foregroundColor(.secondary)
                                            .frame(width: Constants.frameSize, height: Constants.frameSize)
                                    }
                                    Text(user.login)
                                        .font(.title3)
                                }.padding()
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
        static let cornerRadius: Double = 10
        static let frameSize: Double = 160
    }
}

#Preview {
    let viewModel = GithubViewModel()
    return ContentView(viewModel: viewModel)
}
