//
//  DetailsNetworkTarget.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import Combine

/// Object responsible for fetching network data for post details page.
class DetailsNetworkTarget {
    
    // MARK: - Properties
    private let commentsSignal: CurrentValueSubject<[Comment], Never>
    
    init(commentsSignal: CurrentValueSubject<[Comment], Never>) {
        self.commentsSignal = commentsSignal
    }
    
    // MARK: - Instance Methods
    /// Fetches the comments for a specific posts
    func fetchCommentData(id: String) {
        guard let url = URL(string: "\(String.baseNetworkURL)comments?postId=\(id)") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let comments = try? JSONDecoder().decode([Comment].self, from: data) else { return }
            self.commentsSignal.send(comments)
        }.resume()
    }
}
