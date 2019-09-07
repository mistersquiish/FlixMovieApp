//
//  InitialReviewViewController.swift
//  MovieLemma
//
//  Created by Henry Vuong on 8/22/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase

class InitialReviewViewController: UIViewController, didRate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    
    var movies: [Movie] = []
    var reviews: [Review] = []
    var currentViewControllerIndex = 0
    var db: Firestore!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        
        
        // get current user
        currentUser = Auth.auth().currentUser
        
        // UI
        continueButtonOutlet.alpha = 0
        contentView.backgroundColor = ColorScheme.grayColor2
        view.backgroundColor = ColorScheme.grayColor2
        continueButtonOutlet.layer.masksToBounds = false
        continueButtonOutlet.layer.cornerRadius = 12
        continueButtonOutlet.clipsToBounds = true
        continueButtonOutlet.backgroundColor = ColorScheme.goldColor
        continueButtonOutlet.setTitleColor( UIColor.white, for: .normal)
    }
    
    @IBAction func continueButton(_ sender: Any) {
        // save all the reviews to database
        
        for review in reviews {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            var posterUrl = review.movie.posterUrl?.absoluteString
            posterUrl = String((posterUrl?.dropFirst(31))!)
            
            var backdropUrl = review.movie.backdropUrl?.absoluteString
            backdropUrl = String((backdropUrl?.dropFirst(31))!)
            
            var ref: DocumentReference? = nil
            ref = db.collection("reviews").addDocument(data: [
                "user_id": "\(currentUser.uid)",
                "user_email": "\(String(describing: currentUser.email!))",
                "movie": [
                    "title": review.movie.title!,
                    "id": review.movie.movieId!,
                    "overview": review.movie.overview!,
                    "poster_path": posterUrl!,
                    "release_date": df.string(from: review.movie.releaseDate!),
                    "backdrop_path": backdropUrl!,
                    "vote_average": review.movie.voteAverage!,
                    "vote_count": review.movie.voteCount!
                ],
                "rating": review.rating!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        
        
    }
    
    
    func configurePageViewController() {
        // configure database
        db = Firestore.firestore()
        // call firebase to get the movies and convert to reviews
        db.collection("movies")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.movies.append(Movie(dictionary: document.data()))
                    }
                    self.reviews = self.createReviews()
                }
                guard let pageViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: InitialReviewPageViewController.self)) as? InitialReviewPageViewController else {
                    return
                }
                pageViewController.delegate = self
                pageViewController.dataSource = self
                
                self.addChildViewController(pageViewController)
                pageViewController.didMove(toParentViewController: self)
                
                pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
                self.contentView.addSubview(pageViewController.view)
                
                let views: [String: Any] = ["pageView": pageViewController.view!]
                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
                
                self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
                
                guard let startingViewController = self.detailViewControllerAt(index: self.currentViewControllerIndex) else {
                    return
                }
                
                pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true)
        }
        
        
    }
    
    func detailViewControllerAt(index: Int) -> InitialReviewDataViewController? {
        if index >= movies.count || movies.count == 0 {
            return nil
        }
        
        
        guard let dataViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: InitialReviewDataViewController.self)) as? InitialReviewDataViewController else {
            return nil
        }
        // set values for pages
        dataViewController.index = index
        dataViewController.displayText = movies[index].title
        dataViewController.imageURL = movies[index].posterUrl
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        dataViewController.dateText = df.string(from: movies[index].releaseDate!)
        dataViewController.rating = reviews[index].rating
        dataViewController.didRateDelegate = self
        
        return dataViewController
    }

    func createReviews() -> [Review] {
        var reviews: [Review] = []
        
        for movie in movies {
            reviews.append(Review(movie: movie, userId: currentUser.uid, rating: 0))
        }
        
        return reviews
    }
    
    // delegate method for when rating buttons are pushed
    func didRate(index: Int, rating: Int) {
        
        // update reviews
        reviews[index].rating = rating
        
        // check if all reviews are complete, if so then present the 'next' button
        var didFinishReviews = true
        for review in reviews {
            if review.rating == 0 {
                didFinishReviews = false
                break
            }
        }
        
        if didFinishReviews {
            continueButtonOutlet.alpha = 1
        }
    }
}

extension InitialReviewViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationIndex(for InitialReviewPageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return movies.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? InitialReviewDataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        
        currentViewControllerIndex = currentIndex
        
        if currentIndex == 0 {
            return nil
        }
        
        currentIndex -= 1
        
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? InitialReviewDataViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        // update ratings
        //reviews[currentViewControllerIndex].rating = Int((dataViewController?.ratingLabel.text)!)
                
        if currentIndex == movies.count {
            return nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex

        return detailViewControllerAt(index: currentIndex)
    }
}
