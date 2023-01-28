//
//  AuthorsPageManager.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import Combine

/// Manager for the Author information page.
class AuthorInfoPageManager {
    
    // MARK: - Properties
    let photosSignal = CurrentValueSubject<[Photo], Never>.init([])
    let albumsSignal = CurrentValueSubject<[Album], Never>.init([])
    let authorViewControllerSignal: CurrentValueSubject<AuthorInfoViewModel?, Never>
    let networkTarget: AuthorPhotosNetworkTarget
    var observations = Set<AnyCancellable>()
    
    init(authorViewControllerSignal: CurrentValueSubject<AuthorInfoViewModel?, Never>) {
        networkTarget = AuthorPhotosNetworkTarget(photosSignal: photosSignal, albumsSignal: albumsSignal)
        self.authorViewControllerSignal = authorViewControllerSignal
        subscribeToSignals()
    }
    
    // MARK: - Instance Methods
    /// We need to fetch the posts and the list of authors to populate the first page.
    func fetchPhotosForAuthorId(id: String) {
        networkTarget.fetchAlbumsForGivenAuthor(id: id)
    }

    /// Update the viewModel with the posts and the Authors.
    func subscribeToSignals() {
        observations.removeAll()
        
        albumsSignal.dropFirst().sink(receiveValue: { [weak self] albums in
            guard let self = self, !albums.isEmpty else { return }
            self.networkTarget.fetchAllPhotos()
        }).store(in: &observations)
        
        photosSignal.dropFirst().sink(receiveValue: { [weak self] photos in
            let albums = self?.albumsSignal.value
            guard let self = self,
                  !photos.isEmpty,
                  let albums = albums,
                  let viewModel = self.authorViewControllerSignal.value,
                  !albums.isEmpty else { return }
            // We only want photos that are live in one of the albums owned by the selected author of a post.
            let filteredPhotos = photos.filter({ photo in
                return albums.contains(where: {$0.albumId == photo.albumId})
            })
    
            self.authorViewControllerSignal.send(.init(photos: filteredPhotos, author: viewModel.author))
        }).store(in: &observations)
    }
}

