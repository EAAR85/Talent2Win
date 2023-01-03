//
// Storyboarded.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import Foundation
import UIKit

protocol Storyboarded {
    
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
    static func instantiate(_ sb: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: sb, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
}
