//
//  SuperheroViewController.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/18/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    var movies: [[String: Any]] = []
    // searchbar variables
    var filtered: [[String: Any]] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // search bar configuration
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Superhero Movies"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
        
        // layout configuration
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        fetchSuperheroMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return movies.count    //return number of rows in section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movie: [String: Any]!
        if searchActive {
            movie = filtered[indexPath.item]
        } else {
            movie = movies[indexPath.item]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperHeroCell", for: indexPath) as! SuperHeroCell
        if let posterStr = movie["poster_path"] as? String {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + posterStr)!
            cell.posterView.af_setImage(withURL: posterURL)
        }
        return cell
    }
    
    //MARK: Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        filtered = movies.filter() { (movie) -> Bool in
            let movieTitleText: NSString = movie["title"] as! NSString
            
            return (movieTitleText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        }
        
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func fetchSuperheroMovies() {
        // URL request for similar movies to "Black Panther" (Superhero)
        let url = URL(string: "https://api.themoviedb.org/3/movie/284054/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // This will run when the network request returns
            if let error = error {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchSuperheroMovies()
                }
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                // Reload the tableView now that there is new data
                self.collectionView.reloadData()
                // Tell the refreshControl to stop spinning
                //self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
}
