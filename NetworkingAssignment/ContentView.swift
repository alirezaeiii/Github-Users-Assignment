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
        case Resource.success(let user):
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: user.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .foregroundColor(.secondary)
                        .frame(width: 120, height: 120)
                }
                
                Text(user.login)
                    .bold()
                    .font(.title3)
                
                Text(user.bio ?? "Bio Placeholder")
                    .padding()
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    let viewModel = GithubViewModel()
    return ContentView(viewModel: viewModel)
}
