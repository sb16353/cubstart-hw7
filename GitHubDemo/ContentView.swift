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
        guard !username.isEmpty else { return } // Ensure username is not empty
        isSearching = true
        do {
            user = try await getUser(username: username)
        } catch GitError.invalidURL {
            print("Invalid URL")
        } catch GitError.invalidResponse {
            print("Invalid Response")
        } catch GitError.invalidData {
            print("Invalid Data")
        } catch {
            print("Unknown Error")
        }
        isSearching = false
    }
}

//GET
func getUser(username: String) async throws -> GitUser {
    let endpoint = "https://api.github.com/users/\(username)"
    
    guard let url = URL(string: endpoint) else {
        throw GitError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GitError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GitUser.self, from: data)
    } catch {
        throw GitError.invalidData
    }
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
