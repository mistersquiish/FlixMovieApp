//
//  GiveRatingViewController.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 9/3/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import Firebase

class GiveRatingViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var starOutlet1: UIButton!
    @IBOutlet weak var starOutlet2: UIButton!
    @IBOutlet weak var starOutlet3: UIButton!
    @IBOutlet weak var starOutlet4: UIButton!
    @IBOutlet weak var starOutlet5: UIButton!
    
    var db: Firestore!
    var currentUser: User!
    var movie: Movie!
    var currenUserRating: Double!
    var rating: Int!
    var stars: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        titleLabel.text = movie.title
        titleLabel.textColor = ColorScheme.goldColor
        cancelButtonOutlet.tintColor = ColorScheme.goldColor
        imageView.af_setImage(withURL: movie.posterUrl!)
        view.backgroundColor = ColorScheme.grayColor2
        submitButtonOutlet.layer.masksToBounds = false
        submitButtonOutlet.layer.cornerRadius = 12
        submitButtonOutlet.clipsToBounds = true
        submitButtonOutlet.backgroundColor = ColorScheme.goldColor
        submitButtonOutlet.setTitleColor( UIColor.white, for: .normal)
        
        stars = [starOutlet1, starOutlet2, starOutlet3, starOutlet4, starOutlet5]
        
        currentUser = Auth.auth().currentUser
        db = Firestore.firestore()
        
        getCurrentUserRating()
    }
    
    @IBAction func ratingsButton(_ sender: UIButton) {
        for i in 0..<sender.tag {
            stars[i].setImage(UIImage(named: "star_filled"), for: .normal)
        }
        
        for i in sender.tag..<5 {
            stars[i].setImage(UIImage(named: "star"), for: .normal)
        }
        
        rating = sender.tag
    }

    @IBAction func submitButton(_ sender: Any) {
        if (rating != nil || rating != 0) {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            var posterUrl = movie.posterUrl?.absoluteString
            posterUrl = String((posterUrl?.dropFirst(31))!)
            
            var backdropUrl = movie.backdropUrl?.absoluteString
            backdropUrl = String((backdropUrl?.dropFirst(31))!)
            
            var ref: DocumentReference? = nil
            ref = db.collection("reviews").addDocument(data: [
                "user_id": "\(currentUser.uid)",
                "user_email": "\(String(describing: currentUser.email!))",
                "movie": [
                    "title": movie.title!,
                    "id": movie.movieId!,
                    "overview": movie.overview!,
                    "poster_path": posterUrl!,
                    "release_date": df.string(from: movie.releaseDate!),
                    "backdrop_path": backdropUrl!,
                    "vote_average": movie.voteAverage!,
                    "vote_count": movie.voteCount!
                ],
                "rating": rating
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCurrentUserRating() {
        db.collection("reviews").whereField("user_id", isEqualTo: currentUser.uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let movieData = document.data()["movie"] {
                            let movie = Movie(dictionary: movieData as! [String : Any])
                            if movie.movieId == self.movie.movieId {
                                self.currenUserRating = document.data()["rating"] as? Double
                                self.ratingsButton(self.stars[Int(self.currenUserRating)])
                            }
                        }
                        
                    }
                }
        }
    }
}
