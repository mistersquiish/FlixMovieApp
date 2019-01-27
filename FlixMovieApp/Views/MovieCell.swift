//
//  MovieCell.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/12/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    var movie: Movie! {
        willSet {
            if newValue != nil {
                titleLabel.text = newValue.title
                imageLabel.af_setImage(withURL: newValue.posterUrl!)
            }
            self.imageLabel.layer.borderWidth = 1
            self.imageLabel.layer.masksToBounds = false
            self.imageLabel.layer.borderWidth = 0
            self.imageLabel.layer.cornerRadius = 20
            self.imageLabel.clipsToBounds = true
            
            self.backgroundColor = ColorScheme.grayColor
            self.voteAverage.text = String(format:"%.2f", newValue.voteAverage!)
            
            var ratingColor = UIColor(red: 0.27, green: 0.62, blue: 0.27, alpha: 1);
            switch(Int(newValue.voteAverage!)) {
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
            self.voteAverage.backgroundColor = ratingColor
            self.voteAverage.layer.borderWidth = 1
            self.voteAverage.layer.masksToBounds = false
            self.voteAverage.layer.borderWidth = 0
            self.voteAverage.layer.cornerRadius = 5
            self.voteAverage.clipsToBounds = true
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            self.voteCount.text = numberFormatter.string(from: NSNumber(value:newValue.voteCount!))! + " Reviews"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            self.dateLabel.text = dateFormatter.string(from: newValue.releaseDate!)
        }
    }
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var voteAverage: UILabel!
    
    @IBOutlet weak var voteCount: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
