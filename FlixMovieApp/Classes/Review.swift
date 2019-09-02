//
//  Review.swift
//  MovieLemma
//
//  Created by Henry Vuong on 8/22/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import Foundation

class Review {
    var movie: Movie!
    var userId: String!
    var rating: Int!
    
    init(movie: Movie, userId: String, rating: Int) {
        self.movie = movie
        self.userId = userId
        self.rating = rating
    }
    
}
