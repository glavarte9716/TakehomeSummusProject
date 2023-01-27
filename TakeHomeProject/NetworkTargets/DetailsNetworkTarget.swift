//
//  DetailsNetworkTarget.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import Combine

class DetailsNetworkTarget {
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    let commentsSignal: CurrentValueSubject<[Comment], Never>
    
    init(commentsSignal: CurrentValueSubject<[Comment], Never>) {
        self.commentsSignal = commentsSignal
    }
    
    /// Fetches the comments for a specific posts
    public func fetchCommentData(id: String) {
        guard let url = URL(string: "\(baseUrl)comments?postId=\(id)") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let comments = try? JSONDecoder().decode([Comment].self, from: data) else { return }
            self.commentsSignal.send(comments)
        }.resume()
    }
}
