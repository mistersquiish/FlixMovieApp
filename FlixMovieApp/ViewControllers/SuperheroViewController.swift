//
//  SuperheroViewController.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/18/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class SuperheroViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIScrollViewDelegate {

    var movies: [Movie] = []
    // searchbar variables
    var filtered: [Movie] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    // scrollView variables
    var isMoreDataLoading = false
    // infinite scroll loading variables
    var loadingMoreView: InfiniteScrollView?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collection view layout configuration
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = ColorScheme.grayColor
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 2
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = collectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
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
            searchTextField!.attributedPlaceholder = NSAttributedString(string: "Search for Superhero Movies", attributes: attributeDict)
            searchTextField!.backgroundColor = ColorScheme.grayColor
            searchTextField!.textColor = ColorScheme.goldColor
        }
        searchController.searchBar.tintColor = ColorScheme.goldColor
        searchController.searchBar.backgroundColor = ColorScheme.grayColor
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchController.searchBar
        
        // Infinite Scroll loading indicator configuration
        let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
        loadingMoreView = InfiniteScrollView(frame: frame)
        loadingMoreView!.isHidden = true
        collectionView.addSubview(loadingMoreView!)
        var insets = collectionView.contentInset
        insets.bottom += InfiniteScrollView.defaultHeight
        collectionView.contentInset = insets
        
        fetchSuperheroMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        } else {
            return movies.count    //return number of rows in section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movie: Movie!
        if searchActive {
            movie = filtered[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuperHeroCell", for: indexPath) as! SuperHeroCell
        cell.movie = movie
        return cell
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Compute the dimension of a cell for an NxN layout with space S between
        // cells.  Take the collection view's width, subtract (N-1)*S points for
        // the spaces between the cells, and then divide by N to find the final
        // dimension for the cell's width and height.
        
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: 220)
    }
    */
    //MARK: Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        filtered = movies.filter() { (movie) -> Bool in
            let movieTitleText: NSString = movie.title! as NSString
            
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
    
    //MARK: Scroll View
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = collectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && collectionView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: collectionView.contentSize.height, width: collectionView.bounds.size.width, height: InfiniteScrollView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                loadMoreSuperheroMovies()
            }
        }
    }
    
    // network requests to Movie Database API
    func loadMoreSuperheroMovies() {
        MovieApiManager().loadMoreSuperheroMovies { (movies: [Movie]?, error: Error?) in
            if error != nil {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchSuperheroMovies()
                }
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                for movie in movies {
                    self.movies.append(movie)
                }
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                // Reload the tableView now that there is new data
                self.collectionView.reloadData()
                // Update Flag
                self.isMoreDataLoading = false
            }
        }
    }
    
    func fetchSuperheroMovies() {
        MovieApiManager().superheroMovies { (movies: [Movie]?, error: Error?) in
            if error != nil {
                // present an alertController if no network is established
                let alertController = UIAlertController(title: "Cannot Get Movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
                let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (action) in
                    self.fetchSuperheroMovies()
                }
                alertController.addAction(tryAgainAction)
                self.present(alertController, animated: true)
            } else if let movies = movies {
                self.movies = movies
                // Reload the collectionView now that there is new data
                self.collectionView.reloadData()
            }
        }
    }
    
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! SuperHeroCell
        if let indexPath = collectionView.indexPath(for: cell) {
            var movie: Movie!
            if searchActive {
                movie = filtered[indexPath.row]
            } else {
                movie = movies[indexPath.row]
            }
            let destinationViewController = segue.destination as! DetailViewController
            destinationViewController.movie = movie
        }
    }
}
