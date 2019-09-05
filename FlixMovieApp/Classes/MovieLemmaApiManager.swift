//
//  MovieLemmaApiManager.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 9/3/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import Foundation
import FirebaseAuth

class MovieLemmaApiManager {
    
    static let baseUrl = "https://537c447d.ngrok.io/"
    static let currentUserId = Auth.auth().currentUser?.uid
    static let recommendationRoute = "recommendation/"
    var session: URLSession
    
    init() {
        // Configure session so that completion handler is executed on main UI thread
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func recommendedMovies(completion: @escaping ([Movie]?, Error?) -> ()) {
        let url = URL(string: MovieLemmaApiManager.baseUrl + MovieLemmaApiManager.recommendationRoute + MovieLemmaApiManager.currentUserId!)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let movieDictionaries = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
                let movies = Movie.movies(dictionaries: movieDictionaries)
                completion(movies, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
