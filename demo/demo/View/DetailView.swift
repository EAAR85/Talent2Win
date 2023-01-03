//
// DetailView.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import UIKit

class DetailView: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameTag: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item:Product?=nil
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
 
    private func setData(){
        let imageUrl = item?.imageUrl ?? ""
        let url = URL(string: imageUrl)
         
        let placeHolder = UIImage(named: "nofound")
        photoImage.sd_setImage(with: url, placeholderImage: placeHolder,  options: [])
        
        nameLabel.text = item?.name
        nameTag.text = item?.tagline
        descriptionLabel.text = item?.description
    }
    
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
