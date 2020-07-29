//
//  APiRequestActions.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 16.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//

import Foundation

class ApiRequestActions {
    
    private let apiKey = "5dee5bce01639473b1f87fcc23b2ad15"
    

    func getValue(completion: @escaping (Result<FixerResponse, Error>) -> Void) {
    
        URLSession.shared.dataTask(with: URL(string: "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=UAH,USD")!) { (data, response, error) -> Void in
            
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    let response = try JSONDecoder().decode(FixerResponse.self, from: data!)
                    completion(.success(response))
                    
                } catch let error {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
