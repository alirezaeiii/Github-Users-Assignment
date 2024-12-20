//
//  UserColumn.swift
//  NetworkingAssignment
//
//  Created by Ali on 11/15/24.
//

import SwiftUI

struct UserColumn: View {
    let user: GithubUser
    @Binding var navigationPath: [NavigationPath]
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
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
            .onTapGesture {
                navigationPath.append(.detail(user: user))
            }
    }
    
    private struct Constants {
        static let cornerRadius: Double = 10
        static let frameSize: Double = 160
    }
}

#Preview {
    let user = GithubUser(login: "Ali", avatarUrl: "https://avatars.githubusercontent.com/u/2465559?v=4", bio: "Bio")
    @State var navigationPath = [NavigationPath]()
    return UserColumn(user: user, navigationPath: $navigationPath)
}
