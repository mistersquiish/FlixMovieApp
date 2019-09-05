//
//  SearchViewController.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 9/5/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchViewController: UICollectionViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var movies: [Movie] = []

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // collection view layout configuration
 
        collectionView!.backgroundColor = ColorScheme.grayColor
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView!.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        
        // search bar configuration
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        let searchTextField: UITextField? = searchController.searchBar.value(forKey: "searchField") as? UITextField
        if searchTextField!.responds(to: #selector(getter: UITextField.attributedPlaceholder)) {
            let attributeDict = [NSAttributedStringKey.foregroundColor: ColorScheme.goldColor]
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search for movies", attributes: attributeDict)
            searchTextField!.backgroundColor = ColorScheme.grayColor
            searchTextField!.textColor = ColorScheme.goldColor
        }
        searchController.searchBar.tintColor = ColorScheme.goldColor
        searchController.searchBar.backgroundColor = ColorScheme.grayColor
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchController.searchBar

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movie: Movie!
        movie = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperHeroCell", for: indexPath) as! SuperHeroCell
        cell.movie = movie
        return cell
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        collectionView!.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchString = searchController.searchBar.text
        searchMovies(searchString: searchString!)
        collectionView!.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        collectionView!.reloadData()
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchMovies(searchString: String) {
        MovieApiManager().searchMovies(searchString: searchString) { (movies: [Movie]?, error: Error?) in
            if error != nil {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                }
                alertController.addAction(cancelAction)
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                self.movies = movies
                // Reload the collectionView now that there is new data
                self.collectionView!.reloadData()
            }
        }
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! SuperHeroCell
        if let indexPath = collectionView!.indexPath(for: cell) {
            var movie: Movie!
            movie = movies[indexPath.row]
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.movie = movie
        }
    }

}
