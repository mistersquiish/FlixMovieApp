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
                overviewLabel.text = newValue.overview
                imageLabel.af_setImage(withURL: newValue.posterUrl!)
            }
        }
    }
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
