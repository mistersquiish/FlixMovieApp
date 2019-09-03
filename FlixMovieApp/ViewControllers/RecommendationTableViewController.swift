//
//  RecommendationTableViewController.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 9/2/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import AlamofireImage
import FirebaseFirestore

class RecommendationTableViewController: UITableViewController {

    var movies: [Movie] = []
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = ColorScheme.grayColor
        
        // refresh control
        self.refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        self.tableView.insertSubview(refreshControl!, at: 0)
        db = Firestore.firestore()
        
        fetchMovies()
//        // for uploading movies to database for use in onboarding screen
//        uploadMovies()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedCell", for: indexPath) as! RecommendedCell
        cell.movie = movies[indexPath.row]
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = self.tableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.movie = movie
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    func fetchMovies() {
        MovieLemmaApiManager().recommendedMovies { (movies: [Movie]?, error: Error?) in
            if error != nil {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchMovies()
                }
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                self.movies = movies
                // Reload the tableView now that there is new data
                self.tableView.reloadData()
                // Tell the refreshControl to stop spinning
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    /*
    // used only to upload movies to Firebase for tutorial screen
    func uploadMovies() {
        MovieApiManager().topRated { (movies: [Movie]?, error: Error?) in
            if error != nil {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchMovies()
                }
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                let moviesFirst10 = movies.prefix(14)
                
                for movie in moviesFirst10 {
                    var ref: DocumentReference? = nil
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd"
                    var posterUrl = movie.posterUrl?.absoluteString
                    posterUrl = String((posterUrl?.dropFirst(31))!)
                    
                    ref = self.db.collection("movies").addDocument(data: [
                        "title": movie.title!,
                        "id": movie.movieId!,
                        "overview": movie.overview!,
                        "poster_path": posterUrl,
                        "release_date": df.string(from: movie.releaseDate!),
                        "backdrop_path": movie.backdropUrl?.absoluteString,
                        "vote_average": movie.voteAverage!,
                        "vote_count": movie.voteCount!
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
                }
            }
        }
    }
    */
    
 
 

}
