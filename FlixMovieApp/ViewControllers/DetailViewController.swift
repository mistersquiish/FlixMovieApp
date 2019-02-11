//
//  DetailViewController.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/18/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UITextView!
    
    @IBOutlet weak var voteAverage: UILabel!
    
    @IBOutlet weak var voteCount: UILabel!

    @IBOutlet weak var trailerWebView: WKWebView!
    
    @IBOutlet weak var overviewUIView: UIView!
    
    @IBOutlet weak var trailerUIView: UIView!
    
    @IBOutlet weak var castUIView: UIView!
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBAction func trailerButton(_ sender: Any) {
        performSegue(withIdentifier: "TrailerSegue", sender: nil)
    }
    
    var movie: Movie!
    var trailerUrl = URL(string: "https://www.youtube.com/")
    var casts: [Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // collection view layout configuration
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.backgroundColor = ColorScheme.grayColor
        let layout = castCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 5
        let interItemSpacingTotal = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = castCollectionView.frame.size.width / cellsPerLine - interItemSpacingTotal / cellsPerLine
        layout.itemSize = CGSize(width: width, height: width * 3 / 2)
        castCollectionView.backgroundColor = ColorScheme.grayColor2
        
        // API cast request to fill collection view
        MovieApiManager().cast(movie: movie) { (casts: [Cast]?, error: Error?) in
            if error != nil {
                
            } else if let casts = casts {
                self.casts = casts
                self.castCollectionView.reloadData()
            }
        }
        
        if let movie = movie {
            movieLabel.text = movie.title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd,yyyy"
            releaseDateLabel.text = dateFormatter.string(from: movie.releaseDate!)
            
            voteAverage.text = String(format:"%.2f", movie.voteAverage!)
            
            var ratingColor = UIColor(red: 0.27, green: 0.62, blue: 0.27, alpha: 1);
            switch(Int(movie.voteAverage!)) {
            case 9..<10: ratingColor = UIColor(red: 0.223, green: 0.52, blue: 0.223, alpha: 1);
            case 8..<9: ratingColor = UIColor(red: 0.28, green: 0.52, blue: 0.223, alpha: 1);
            case 7..<8: ratingColor = UIColor(red: 0.35, green: 0.52, blue: 0.223, alpha: 1);
            case 6..<7: ratingColor = UIColor(red: 0.95, green: 0.6, blue: 0.071, alpha: 1);
            case 5..<6: ratingColor = UIColor(red: 0.90, green: 0.5, blue: 0.13, alpha: 1);
            case 4..<5: ratingColor = UIColor(red: 0.83, green: 0.33, blue: 0.33, alpha: 1);
            case 2..<4: ratingColor = UIColor(red: 0.91, green: 0.3, blue: 0.235, alpha: 1);
            case 0..<2: ratingColor = UIColor(red: 0.75, green: 0.22, blue: 0.22, alpha: 1);
            default: break;
            }
            voteAverage.backgroundColor = ratingColor
            
            overviewLabel.text = movie.overview
            posterImageView.af_setImage(withURL: movie.posterUrl!)
            backgroundImageView.af_setImage(withURL: movie.backdropUrl!)
            fetchMovieTrailer()
        }
        self.view.backgroundColor = ColorScheme.grayColor
        
        movieLabel.textColor = UIColor.white
        releaseDateLabel.textColor = UIColor.white
        overviewLabel.textColor = UIColor.white
        overviewLabel.backgroundColor = ColorScheme.grayColor2
        overviewLabel.isEditable = false
        
        trailerUIView.backgroundColor = ColorScheme.grayColor2
        castUIView.backgroundColor = ColorScheme.grayColor2
        trailerWebView.backgroundColor = ColorScheme.grayColor2
        trailerWebView.isOpaque = false
        
        posterImageView.layer.borderWidth = 1
        posterImageView.layer.masksToBounds = false
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.cornerRadius = 20
        posterImageView.clipsToBounds = true
        
        roundEdges(view: voteAverage)
        roundEdges(view: overviewUIView)
        roundEdges(view: trailerUIView)
        roundEdges(view: castUIView)
        roundEdges(view: trailerWebView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func swipeLeftGesture(_ sender: UISwipeGestureRecognizer) {
        if castUIView.frame.minX - 16 != self.view.frame.minX  {
            let numIncrement = (self.overviewUIView.frame.width + 8) * -1
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            self.overviewUIView.frame = self.overviewUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
                            self.trailerUIView.frame = self.trailerUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
                            self.castUIView.frame = self.castUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
            },
                           completion: nil)
        } else {
            let translation = CGFloat(171.5) * -1
            let originalCenterCast = castUIView.center
            let originalCenterTrailer = trailerUIView.center
            UIView.animate(withDuration:0.5, animations: {
                self.trailerUIView.center = CGPoint(x: originalCenterTrailer.x + translation, y: originalCenterTrailer.y)
                self.castUIView.center = CGPoint(x: originalCenterCast.x + translation, y: originalCenterCast.y)
            })
            
            UIView.animate(withDuration:0.6, animations: {
                self.castUIView.center = originalCenterCast
                self.trailerUIView.center = originalCenterTrailer
            })
            
        }
        
    }
    
    @IBAction func swipeRightGesture(_ sender: UISwipeGestureRecognizer) {
        if overviewUIView.frame.minX - 16 != self.view.frame.minX {
            let numIncrement = (self.overviewUIView.frame.width + 8)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: {
                            self.overviewUIView.frame = self.overviewUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
                            self.trailerUIView.frame = self.trailerUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
                            self.castUIView.frame = self.castUIView.frame.offsetBy(dx: numIncrement, dy: 0.0);
            },
                           completion: nil)
        } else {
            let translation = CGFloat(171.5) * -1
            let originalCenterOverview = overviewUIView.center
            let originalCenterTrailer = trailerUIView.center
            UIView.animate(withDuration:0.5, animations: {
                self.trailerUIView.center = CGPoint(x: originalCenterTrailer.x + translation, y: originalCenterTrailer.y)
                self.overviewUIView.center = CGPoint(x: originalCenterOverview.x + translation, y: originalCenterOverview.y)
            })
            
            UIView.animate(withDuration:0.4, animations: {
                self.overviewUIView.center = originalCenterOverview
                self.trailerUIView.center = originalCenterTrailer
            })
            
        }
        
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count > 10 ? 10 : casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cast = casts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell
        cell.cast = cast
        return cell
    }
    
    func fetchMovieTrailer() {
        MovieApiManager().movieTrailer(movie: self.movie) { (trailerUrl: URL?, error: Error?) in
            if error != nil {
                
            } else if let trailerUrl = trailerUrl {
                self.trailerUrl = trailerUrl
                self.trailerWebView.load(URLRequest(url: self.trailerUrl!))
            }
        }
    }
    
    func roundEdges(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.masksToBounds = false
        view.layer.borderWidth = 0
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
}
