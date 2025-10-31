//
//  ContentView.swift
//  GitHubDemo
//
//  Created by Dylan Chhum on 10/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitUser? 
    @State private var username: String = ""
    @State private var isSearching: Bool = false


    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.1, blue: 0.1)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    TextField("Enter GitHub Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Search") {
                        Task {
                            await fetchUser()
                        }
                    }
                    .padding(.trailing)
                }
                
                if isSearching {
                    ProgressView("Loading...")
                } else {
                    AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                    } placeholder: {
                        Circle()
                            .foregroundColor(.secondary)
                            .frame(width: 200, height: 200)
                    }
                    
                    Text(user?.login ?? "Username Placeholder")
                        .bold()
                        .font(.title)
                        .foregroundStyle(Color.white)
                    
                    Text(user?.bio ?? "Bio Placeholder")
                        .padding()
                        .foregroundStyle(Color.white)
                }
                
                Spacer()
            }
            .padding()
        }
    }

    // ViewModel
    func fetchUser() async {
        // TODO: Complete this function use try and catch blocks



    }
}

//GET
func getUser(username: String) async throws -> GitUser {
    // TODO: Complete this function
    // Hint: The GitHub API endpoint format is "https://api.github.com/users/{username}"
    let endpoint = ""

    // Remove this placeholder return once you implement the function
    return GitUser(login: "", avatarUrl: "", bio: "")
}

// Model
struct GitUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GitError : Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
