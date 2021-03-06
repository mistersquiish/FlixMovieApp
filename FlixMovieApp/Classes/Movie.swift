//
//  Movie.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 3/15/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import Foundation

class Movie {
    var title: String?
    var movieId: String?
    var overview: String?
    var posterUrl: URL?
    var releaseDate: Date?
    var backdropUrl: URL?
    var voteAverage: Double?
    var voteCount: Int?
    var predictedRating: Double?
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        voteAverage = dictionary["vote_average"] as? Double ?? 0.00
        voteCount = dictionary["vote_count"] as? Int ?? 0
        if let id = dictionary["id"] {
            movieId = String(describing: id)
        }
        overview = dictionary["overview"] as? String ?? "No overview"
        
        if let posterStr = dictionary["poster_path"] as? String {
            posterUrl = URL(string: "https://image.tmdb.org/t/p/w500" + posterStr)!
        }
        
        // convert string to date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        releaseDate = dateFormatter.date(from: dictionary["release_date"] as! String)
        
        if let backdropStr = dictionary["backdrop_path"] as? String {
            backdropUrl = URL(string: "https://image.tmdb.org/t/p/w500" + backdropStr)!
        }
        
        predictedRating = dictionary["predicted_rating"] as? Double ?? 0.0
    }
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
