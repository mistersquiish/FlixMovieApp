//
//  MovieApiManager.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 3/16/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import Foundation

class MovieApiManager {
    
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var superheroPageCount = 2
    var session: URLSession
    
    init() {
        // Configure session so that completion handler is executed on main UI thread
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func nowPlayingMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseUrl + "now_playing?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func superheroMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseUrl + "284054/similar?api_key=\(MovieApiManager.apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func loadMoreSuperheroMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseUrl + "284054/similar?api_key=\(MovieApiManager.apiKey)&language=en-US&page=\(superheroPageCount)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // testForNil will test to see if the "results" array is empty. Only important when we hit the end page of loading more superhero movies (page 61+)
                let testForCount = dataDictionary["results"] as? [String]
                if testForCount?.count != 0 {
                    let moviesAddDictionary = dataDictionary["results"] as! [[String: Any]]
                    // ... Use the new data to update the data source ...
                    self.superheroPageCount += 1
                
                    let movies = Movie.movies(dictionaries: moviesAddDictionary)
                    completion(movies, nil)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func popularMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieApiManager.baseUrl + "popular?api_key=\(MovieApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func movieTrailer(movie: Movie, completion: @escaping (URL?, Error?) -> ()) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.movieId!)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let testForCount = dataDictionary["results"] as? [String]
                if testForCount?.count != 0 {
                    let trailers = dataDictionary["results"] as! [[String: Any]]
                    let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(trailers[0]["key"]!)")!
                    completion(trailerUrl, error)
                }

            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}


