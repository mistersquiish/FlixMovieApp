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
    
    var movie: [String: Any]!
    var trailerURL = URL(string: "https://www.youtube.com/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            movieLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            // catch error if no backdrop
            if let backdropStr = movie["backdrop_path"] as? String {
                let backdropURL = URL(string: "https://image.tmdb.org/t/p/w500" + backdropStr)!
                backgroundImageView.af_setImage(withURL: backdropURL)
            }
            let posterStr = movie["poster_path"] as! String
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterStr)!
            posterImageView.af_setImage(withURL: posterURL)
            fetchMovieTrailer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TrailerViewController
        destinationViewController.trailerURL = trailerURL
    }
    
    func fetchMovieTrailer() {
        // URL request for movie trailer link
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie["id"]!)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?)
            in
            // This will run when the network request returns
            if let error = error {
                // present an alertController if can't get trailer
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                var testForCount = dataDictionary["results"] as? [String]
                if testForCount?.count != 0 {
                    let trailers = dataDictionary["results"] as! [[String: Any]]
                    let trailerStr = "https://www.youtube.com/watch?v=\(trailers[0]["key"]!)"
                    self.trailerURL = URL(string: trailerStr)!
                }
            }
        }
        task.resume()
    }
}
