//
// ProductList.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import Foundation

typealias ProductList = [Product]

struct Product: Codable {
    
    var id          : Int?    = nil
    var name        : String? = nil
    var tagline     : String? = nil
    var firstBrewed : String? = nil
    var description : String? = nil
    var imageUrl    : String? = nil
    
    enum CodingKeys: String, CodingKey {

      case id          = "id"
      case name        = "name"
      case tagline     = "tagline"
      case firstBrewed = "first_brewed"
      case description = "description"
      case imageUrl    = "image_url"
    
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)

      id          = try values.decodeIfPresent(Int.self    , forKey: .id          )
      name        = try values.decodeIfPresent(String.self , forKey: .name        )
      tagline     = try values.decodeIfPresent(String.self , forKey: .tagline     )
      firstBrewed = try values.decodeIfPresent(String.self , forKey: .firstBrewed )
      description = try values.decodeIfPresent(String.self , forKey: .description )
      imageUrl    = try values.decodeIfPresent(String.self , forKey: .imageUrl    )
   
    }

    init() {

    }

}
