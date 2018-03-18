//
//  NowPlayingViewController.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/12/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        
        // refresh control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        movieTableView.insertSubview(refreshControl, at: 0)
        
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    func fetchMovies() {
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let error = error {
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
                self.movieTableView.reloadData()
                // Tell the refreshControl to stop spinning
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = movieTableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.movie = movie
        }
    }
}