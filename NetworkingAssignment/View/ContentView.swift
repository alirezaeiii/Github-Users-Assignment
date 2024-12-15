//
//  ContentView.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        AsyncContentView(viewState: viewModel.viewState) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridItemSize))]) {
                    ForEach(viewModel.users) { userWrapper in
                        Section(userWrapper.section) {
                            ForEach(userWrapper.users, id: \.self.login) { user in
                                UserColumn(user: user, navigationPath: $navigationPath)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alirezaiii")
            .navigationBarTitleDisplayMode(.inline)
        } onRetry: {
            Task {
                await viewModel.refresh()
            }
        }.task {
            await viewModel.refresh()
        }
    }
    
    private struct Constants {
        static let gridItemSize: Double = 180
    }
}

#Preview {
    let networkService = NetworkService()
    let viewModel = MainViewModel(networkService: networkService)
    @State var navigationPath = [NavigationPath]()
    return NavigationStack {
        ContentView(viewModel: viewModel, navigationPath: $navigationPath)
    }
}
