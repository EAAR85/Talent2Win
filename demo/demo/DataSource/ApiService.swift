//
// ApiService.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import Foundation

class ApiService {
    
    func list(text:String) async throws -> [Product] {
        
        let param = !text.isEmpty ? "&beer_name=\(text)" : ""
        
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=1\(param)") else {
            throw ApiError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(ProductList.self, from: data)
        
        return result
    }
}
