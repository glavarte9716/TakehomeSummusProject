//
//  DetailPageManager.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import Combine

/// Manager responsible for handling communication with the backend and the viewModel.
class DetailPageManager {
    
    // MARK: - Properties
    private let commentsSignal = CurrentValueSubject<[Comment], Never>.init([])
    private let networkTarget: DetailsNetworkTarget
    private var observations = Set<AnyCancellable>()
    let detailControllerSignal: CurrentValueSubject<PostDetailViewModel?, Never>
    
    init(detailControllerSignal: CurrentValueSubject<PostDetailViewModel?, Never>) {
        networkTarget = DetailsNetworkTarget(commentsSignal: commentsSignal)
        self.detailControllerSignal = detailControllerSignal
        subscribeToSignals()
    }
    
    // MARK: - Instance Methods
    /// We need to fetch the posts and the list of authors to populate the first page.
    func fetchDetailPageData(id: String) {
        networkTarget.fetchCommentData(id: id)
    }

    /// Update the viewModel with the posts and the Authors.
    private func subscribeToSignals() {
        commentsSignal.dropFirst().sink(receiveValue: { [weak self] comments in
            guard let self = self,
                  let viewModel = self.detailControllerSignal.value else { return }
            self.detailControllerSignal.send(.init(comments: comments, post: viewModel.post, author: viewModel.author))
        }).store(in: &observations)
    }

}

