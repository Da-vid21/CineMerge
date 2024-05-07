//
//  ContentView.swift
//  CineMerge3
//
//  Created by Dawit Tekeste on 5/6/24.
//

import SwiftUI

struct Folder: Codable, Identifiable {
    var folderId: Int
    var createdAt: String
    var folderTitle: String
    var folderIcon: String
    var folderColor: String
    var folderGenre: String
    var totalHours: Int
    var userId: Int

    var id: Int {
        return folderId
    }

    // Map JSON keys to struct property names
    enum CodingKeys: String, CodingKey {
        case folderId = "folderId"
        case createdAt = "created_at"
        case folderTitle = "folderTitle"
        case folderIcon = "folderIcon"
        case folderColor = "folderColor"
        case folderGenre = "folderGenre"
        case totalHours = "totalHours"
        case userId = "userId"
    }
}

struct AddFolderView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var networkManager: NetworkManager

    @State private var folderTitle = ""
    @State private var folderIcon = ""
    @State private var folderColor = ""
    @State private var folderGenre = ""
    @State private var totalHours = 0
    @State private var userId = 1

    var body: some View {
        Form {
            Section(header: Text("Folder Details")) {
                TextField("Folder Title", text: $folderTitle)
                TextField("Folder Icon URL", text: $folderIcon)
                TextField("Folder Color (Hex)", text: $folderColor)
                TextField("Folder Genre", text: $folderGenre)
                TextField("Total Hours", value: $totalHours, formatter: NumberFormatter())
            }

            Button("Add Folder") {
                let newFolder = Folder(
                    folderId: -1,  // This will be automatically generated by the server.
                    createdAt: "", // Server will generate this as well.
                    folderTitle: folderTitle,
                    folderIcon: folderIcon,
                    folderColor: folderColor,
                    folderGenre: folderGenre,
                    totalHours: totalHours,
                    userId: userId
                )

                networkManager.addFolder(newFolder: newFolder) { success in
                    if success {
                        networkManager.fetchFolders()
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Error adding the folder.")
                    }
                }
            }
        }
        .navigationTitle("Add Folder")
    }
}

struct ContentView: View {
    @StateObject var networkManager = NetworkManager()
    @AppStorage("isDarkMode") private var isDarkMode = false // Tracks dark mode setting

    var body: some View {
        TabView {
            NavigationView {
                List(networkManager.folders) { folder in
                    NavigationLink(destination: MovieListView(networkManager: networkManager, folderId: folder.folderId)) {
                        FolderCell(folder: folder)
                    }
                }
                .navigationTitle("Folders")
                .toolbar {
                    NavigationLink(destination: AddFolderView(networkManager: networkManager)) {
                        Image(systemName: "plus")
                    }
                }
                .onAppear {
                    networkManager.fetchFolders()
                }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.blue) // Color for tab items
        .environment(\.colorScheme, isDarkMode ? .dark : .light) // Apply dark mode setting
    }
}


struct FolderCell: View {
    var folder: Folder

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: folder.folderIcon)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(folder.folderTitle).font(.headline)
                Text(folder.folderGenre).font(.subheadline)
                Text("Total Hours: \(folder.totalHours)h").font(.subheadline)
            }
        }
    }
}



struct MovieDetailView: View {
    @ObservedObject var networkManager: NetworkManager
    var movieId: Int
    
    @State private var movie: Movie?

    var body: some View {
        VStack {
            if let movie = movie {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        AsyncImage(url: URL(string: movie.movieIcon)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 10) {
                            Text(movie.movieTitle)
                                .font(.title)
                                .fontWeight(.bold)

                            Text(movie.movieDescription)
                                .font(.body)
                            
                            Link(destination: URL(string: movie.movieLink)!) {
                                Text("Watch Now")
                                    .bold()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(40)
                            }
                        }
                        .padding()
                    }
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            networkManager.fetchMovieDetail(movieId: movieId) { fetchedMovie in
                self.movie = fetchedMovie
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}




struct AddMovieView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var networkManager: NetworkManager
    var folderId: Int

    @State private var movieTitle = ""
    @State private var movieDescription = ""
    @State private var movieIcon = ""
    @State private var movieLink = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie Details")) {
                    TextField("Movie Title", text: $movieTitle)
                    TextField("Movie Description", text: $movieDescription)
                    TextField("Movie Icon URL", text: $movieIcon)
                    TextField("Movie Link", text: $movieLink)
                }

                Button("Add Movie") {
                    let newMovie = Movie(
                        movieId: -1, // Assume ID is generated by the server
                        movieTitle: movieTitle,
                        movieDescription: movieDescription,
                        movieIcon: movieIcon,
                        movieLink: movieLink,
                        folderId: folderId
                    )
                    networkManager.addMovie(newMovie: newMovie) { success in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            print("Failed to add movie.")
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Add Movie")
        }
    }
}

struct MovieListView: View {
    @ObservedObject var networkManager: NetworkManager
    var folderId: Int
    @State private var movies: [Movie] = []
    @State private var showingAddMovieView = false // State to manage the presentation of the AddMovieView

    var body: some View {
        List(movies) { movie in
            NavigationLink(destination: MovieDetailView(networkManager: networkManager, movieId: movie.movieId)) {
                HStack {
                    AsyncImage(url: URL(string: movie.movieIcon)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)

                    VStack(alignment: .leading) {
                        Text(movie.movieTitle).font(.headline)
                        Text(movie.movieDescription).lineLimit(1).font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            networkManager.fetchMovies(forFolderId: folderId) { fetchedMovies in
                self.movies = fetchedMovies
            }
        }
        .navigationTitle("Movies")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddMovieView = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddMovieView) {
            AddMovieView(networkManager: networkManager, folderId: folderId)
        }
    }
}


struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        Form {
            Toggle("Dark Mode", isOn: $isDarkMode)
                .onChange(of: isDarkMode) { newValue in
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                }
        }
        .navigationTitle("Settings")
    }
}



#Preview {
    ContentView()
}