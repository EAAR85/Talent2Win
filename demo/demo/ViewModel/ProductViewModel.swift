//
// ProductViewModel.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import Foundation

class ProductViewModel{
    private var api:ApiService? = nil
    
    init() {
        self.api = ApiService()
    }
    
    func list(value:String, _ completion: @escaping (_ data:ProductList?)-> Void) -> Void {
        Task {
            do {

                let result = try await self.api?.list(text: value)                
                completion(result)
            } catch {
                print("Request failed with error: \(error)")
            }
        }
    }
}
