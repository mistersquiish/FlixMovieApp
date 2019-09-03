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
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    
    var db: Firestore!
    var currentUser: User!
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        imageView.af_setImage(withURL: movie.posterUrl!)
        currentUser = Auth.auth().currentUser
        db = Firestore.firestore()
    }
    
    @IBAction func ratingsButton(_ sender: UIButton) {
        ratingLabel.text = String(describing: sender.tag)
    }

    @IBAction func submitButton(_ sender: Any) {
        if (ratingLabel.text != "0") {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            var posterUrl = movie.posterUrl?.absoluteString
            posterUrl = String((posterUrl?.dropFirst(31))!)
            
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
                    "backdrop_path": movie.backdropUrl!.absoluteString,
                    "vote_average": movie.voteAverage!,
                    "vote_count": movie.voteCount!
                ],
                "rating": Int(ratingLabel.text!)!
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
    
    
}
