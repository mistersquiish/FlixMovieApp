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
    
    @IBOutlet weak var overviewLabel: UITextView!
    
    @IBOutlet weak var voteAverage: UILabel!
    
    @IBOutlet weak var voteCount: UILabel!
    
    @IBOutlet weak var trailerButtonUI: UIButton!
    
    
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
            
            voteAverage.text = String(format:"%.2f", movie.voteAverage!)
            
            var ratingColor = UIColor(red: 0.27, green: 0.62, blue: 0.27, alpha: 1);
            switch(Int(movie.voteAverage!)) {
            case 9..<10: ratingColor = UIColor(red: 0.223, green: 0.52, blue: 0.223, alpha: 1);
            case 8..<9: ratingColor = UIColor(red: 0.28, green: 0.52, blue: 0.223, alpha: 1);
            case 7..<8: ratingColor = UIColor(red: 0.35, green: 0.52, blue: 0.223, alpha: 1);
            case 6..<7: ratingColor = UIColor(red: 0.95, green: 0.6, blue: 0.071, alpha: 1);
            case 5..<6: ratingColor = UIColor(red: 0.90, green: 0.5, blue: 0.13, alpha: 1);
            case 4..<5: ratingColor = UIColor(red: 0.83, green: 0.33, blue: 0.33, alpha: 1);
            case 2..<4: ratingColor = UIColor(red: 0.91, green: 0.3, blue: 0.235, alpha: 1);
            case 0..<2: ratingColor = UIColor(red: 0.75, green: 0.22, blue: 0.22, alpha: 1);
            default: break;
            }
            voteAverage.backgroundColor = ratingColor
            
            overviewLabel.text = movie.overview
            posterImageView.af_setImage(withURL: movie.posterUrl!)
            backgroundImageView.af_setImage(withURL: movie.backdropUrl!)
            fetchMovieTrailer()
        }
        self.view.backgroundColor = ColorScheme.grayColor
        
        movieLabel.textColor = UIColor.white
        releaseDateLabel.textColor = UIColor.white
        overviewLabel.textColor = UIColor.white
        overviewLabel.backgroundColor = ColorScheme.grayColor
        overviewLabel.isEditable = false
        
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.masksToBounds = false
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.cornerRadius = 20
        posterImageView.clipsToBounds = true
        
        voteAverage.layer.borderWidth = 1
        voteAverage.layer.masksToBounds = false
        voteAverage.layer.borderWidth = 0
        voteAverage.layer.cornerRadius = 5
        voteAverage.clipsToBounds = true
        
        trailerButtonUI.backgroundColor = ColorScheme.goldColor
        trailerButtonUI.layer.borderWidth = 1
        trailerButtonUI.layer.masksToBounds = false
        trailerButtonUI.layer.borderWidth = 0
        trailerButtonUI.layer.cornerRadius = 15
        trailerButtonUI.clipsToBounds = true
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
