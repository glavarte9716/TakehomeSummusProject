//
//  NetworkTarget.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation
import Combine

/// Object responsible for fetching network data for home page.
class HomeNetworkTarget {
    
    // MARK: - Properties
    private let postsSignal: CurrentValueSubject<[Post], Never>
    private let authorsSignal:  CurrentValueSubject<[Author], Never>
    
    init(postsSignal: CurrentValueSubject<[Post], Never>, authorsSignal: CurrentValueSubject<[Author], Never>) {
        self.postsSignal = postsSignal
        self.authorsSignal = authorsSignal
    }
    
    // MARK: - Instance Methods
    /// Function for retrieving the post data from the API.
    func fetchPostData() {
        guard let url = URL(string: "\(String.baseNetworkURL)posts") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let posts = try? JSONDecoder().decode([Post].self, from: data) else {
                return
            }
            // Pass the poss downstream when request is returned.
            self.postsSignal.send(posts)
        }.resume()
    }
    
    /// Function for retrieving the author data from the API.
    func fetchAuthorData() {
        guard let url = URL(string: "\(String.baseNetworkURL)users") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let authors = try? JSONDecoder().decode([Author].self, from: data)  else { return }
            self.authorsSignal.send(authors)
        }.resume()
    }
}
