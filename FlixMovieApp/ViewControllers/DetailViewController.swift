//
//  DetailViewController.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/18/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            movieLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let backdropStr = movie["backdrop_path"] as! String
            let posterStr = movie["poster_path"] as! String
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterStr)!
            posterImageView.af_setImage(withURL: posterURL)
            let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500" + backdropStr)!
            backgroundImageView.af_setImage(withURL: backdropURL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
