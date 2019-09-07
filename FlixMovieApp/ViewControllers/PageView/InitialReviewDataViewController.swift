//
//  InitialReviewDataViewController.swift
//  MovieLemma
//
//  Created by Henry Vuong on 8/22/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit
import AlamofireImage

protocol didRate {
    func didRate(index: Int, rating: Int)
}

class InitialReviewDataViewController: UIViewController {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starOutlet1: UIButton!
    @IBOutlet weak var starOutlet2: UIButton!
    @IBOutlet weak var starOutlet3: UIButton!
    @IBOutlet weak var starOutlet4: UIButton!
    @IBOutlet weak var starOutlet5: UIButton!

    
    var didRateDelegate: didRate?
    var displayText: String!
    var imageURL: URL!
    var dateText: String!
    var index: Int!
    var stars: [UIButton]!
    var rating: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        movieLabel.text = displayText + " (\(dateText!))"
        movieLabel.textColor = ColorScheme.goldColor
        imageView.af_setImage(withURL: imageURL)
        view.backgroundColor = ColorScheme.grayColor2
        
        stars = [starOutlet1, starOutlet2, starOutlet3, starOutlet4, starOutlet5]
        
        // change rating to whatever the user put previously
        if rating != nil && rating != 0 {
            ratingsButton(stars[rating - 1])

        }
    }
    
    @IBAction func ratingsButton(_ sender: UIButton) {
        for i in 0..<sender.tag {
            stars[i].setImage(UIImage(named: "star_filled"), for: .normal)
        }
        
        for i in sender.tag..<5 {
            stars[i].setImage(UIImage(named: "star"), for: .normal)
        }
        
        didRateDelegate?.didRate(index: index, rating: sender.tag)
    }
    
    
}
