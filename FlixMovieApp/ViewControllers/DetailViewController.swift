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
    
    @IBAction func trailerButton(_ sender: Any) {
        performSegue(withIdentifier: "TrailerSegue", sender: nil)
    }
    
    var movie: Movie!
    var trailerUrl = URL(string: "https://www.youtube.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            movieLabel.text = movie.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            releaseDateLabel.text = dateFormatter.string(from: movie.releaseDate!)
            overviewLabel.text = movie.overview
            posterImageView.af_setImage(withURL: movie.posterUrl!)
            backgroundImageView.af_setImage(withURL: movie.backdropUrl!)
            fetchMovieTrailer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TrailerViewController
        destinationViewController.trailerUrl = trailerUrl
    }
    
    func fetchMovieTrailer() {
        MovieApiManager().movieTrailer(movie: self.movie) { (trailerUrl: URL?, error: Error?) in
            if error != nil {
                
            } else if let trailerUrl = trailerUrl {
                self.trailerUrl = trailerUrl
            }
        }
    }
}
