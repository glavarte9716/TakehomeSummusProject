//
//  Manager.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/25/23.
//

import Foundation
import Combine

/// Manager responsible for handling communication with the backend and the viewModel.
class HomePageManager {
    // MARK: - Properties
    let postsSignal = CurrentValueSubject<[Post], Never>.init([])
    let authorsSignal =  CurrentValueSubject<[Author], Never>.init([])
    let homeViewControllerSignal: CurrentValueSubject<HomeViewModel, Never>
    let networkTarget: NetworkTarget
    var observations = Set<AnyCancellable>()
    
    init(homeViewControllerSignal: CurrentValueSubject<HomeViewModel, Never>) {
        networkTarget = NetworkTarget(postsSignal: postsSignal, authorsSignal: authorsSignal)
        self.homeViewControllerSignal = homeViewControllerSignal
        subscribeToSignals()
    }
    
    /// We need to fetch the posts and the list of authors to populate the first page.
    func fetchHomePageData() {
        networkTarget.fetchPostData()
        networkTarget.fetchAuthorData()
    }

    /// Update the viewModel with the posts and the Authors.
    func subscribeToSignals() {
        postsSignal.dropFirst().sink(receiveValue: { [weak self] posts in
            guard let self = self else { return }
            let viewModel = self.homeViewControllerSignal.value
            self.homeViewControllerSignal.send(.init(posts: posts, authors: viewModel.authors))
        }).store(in: &observations)
        
        authorsSignal.dropFirst().sink(receiveValue: { [weak self] authors in
            guard let self = self else { return }
            let viewModel = self.homeViewControllerSignal.value
            self.homeViewControllerSignal.send(.init(posts: viewModel.posts, authors: authors))
        }).store(in: &observations)
    }

}
