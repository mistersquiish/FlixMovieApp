//
//  CastCell.swift
//  FlixMovieApp
//
//  Created by Henry Vuong on 2/10/19.
//  Copyright © 2019 Henry Vuong. All rights reserved.
//

import UIKit

class CastCell: UICollectionViewCell {
    var cast: Cast! {
        willSet {
            if newValue != nil {
                if let profileUrl = newValue.profileUrl
                {
                    castImageView.af_setImage(withURL: profileUrl)
                } else {
                    castImageView.image = #imageLiteral(resourceName: "user_male")
                }
                
                castImageView.layer.borderWidth = 1
                castImageView.layer.masksToBounds = false
                castImageView.layer.borderWidth = 0
                castImageView.layer.cornerRadius = 5
                castImageView.clipsToBounds = true
                
            }
        }
    }
    
    @IBOutlet weak var castImageView: UIImageView!
    
}
