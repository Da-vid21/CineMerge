//
//  NetworkManager.swift
//  CineMerge3
//
//  Created by Dawit Tekeste on 5/6/24.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var folders: [Folder] = []

    func fetchFolders() {
        guard let url = URL(string: "http://127.0.0.1:5000/getFolders") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Folder].self, from: data)
                    DispatchQueue.main.async {
                        self.folders = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        task.resume()
    }

    func addFolder(newFolder: Folder, completion: @escaping (Bool) -> Void) {
            guard let url = URL(string: "http://127.0.0.1:5000/addFolder") else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONEncoder().encode(newFolder)
                request.httpBody = jsonData

                let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        // Update any UI-related properties here
                        self?.fetchFolders()  // Assuming fetchFolders updates `folders`
                        completion(true)
                    }
                }
                task.resume()
            } catch {
                DispatchQueue.main.async {
                    print("Error encoding movie data: \(error)")
                    completion(false)
                }
            }
        }
    
    func fetchMovies(forFolderId folderId: Int, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/getMovies?folderId=\(folderId)") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let movies = try JSONDecoder().decode([Movie].self, from: data)
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
    func addMovie(newMovie: Movie, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/addMovie") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(newMovie)
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(false)
                    return
                }
                completion(true)
            }
            task.resume()
        } catch {
            print("Error encoding movie data: \(error)")
            completion(false)
        }
    }
    func fetchMovieDetail(movieId: Int, completion: @escaping (Movie?) -> Void) {
            guard let url = URL(string: "http://127.0.0.1:5000/getMovieDetailed?movieId=\(movieId)") else {
                completion(nil)
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    DispatchQueue.main.async {
                        completion(movie)
                    }
                } catch {
                    print("Decoding error: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        }
}
