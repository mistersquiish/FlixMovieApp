//
//  Cast.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 2/10/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import Foundation

class Cast {
    var name: String?
    var character: String?
    var profileUrl: URL?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? "No name"
        character = dictionary["character"] as? String ?? "No character"

        if let profileStr = dictionary["profile_path"] as? String {
            profileUrl = URL(string: "https://image.tmdb.org/t/p/w500" + profileStr)!
        }
    }
    
    class func casts(dictionaries: [[String: Any]]) -> [Cast] {
        var casts: [Cast] = []
        for dictionary in dictionaries {
            let cast = Cast(dictionary: dictionary)
            casts.append(cast)
        }
        
        return casts
    }
}
