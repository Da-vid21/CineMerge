//
//  Movies.swift
//  CineMerge3
//
//  Created by Dawit Tekeste on 5/7/24.
//

import Foundation

struct Movie: Codable, Identifiable {
    var movieId: Int
    var movieTitle: String
    var movieDescription: String
    var movieIcon: String
    var movieLink: String
    var folderId: Int

    var id: Int { movieId }
}


