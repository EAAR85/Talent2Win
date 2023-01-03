//
// MovieViewCell.swift
// Aegis-Cinema
//
// Created by Elvis on 24/05/22.
// Copyright (c) 2022. All rights reserved.
//


import UIKit
import SDWebImage

class MovieViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImage: UIView!
    @IBOutlet weak var imgMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setValue(_ value:Product){
        let imageUrl = value.imageUrl ?? ""
        let url = URL(string: imageUrl)
        
        //self.photoLoader.startAnimating()
        let placeHolder = UIImage(named: "nofound")
        imgMovie.sd_setImage(with: url, placeholderImage: placeHolder,  options: []) { image, error, cacheType, url in
            //self.photoLoader.stopAnimating()
        }
    }
}
