//
//  PosterCell.swift
//  FlixPart1Assignment1
//
//  Created by Henry Vuong on 2/18/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class SuperHeroCell: UICollectionViewCell {
    
    var movie: Movie! {
        willSet {
            if newValue != nil {
                posterView.af_setImage(withURL: newValue.posterUrl!)
            }
        }
    }

    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
