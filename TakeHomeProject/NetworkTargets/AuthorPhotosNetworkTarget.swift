//
//  AuthorPhotosNetworkTarget.swift
//  TakeHomeProject
//
//  Created by Gabe Lavarte on 1/26/23.
//

import Foundation
import Combine

class AuthorPhotosNetworkTarget {
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    let photosSignal: CurrentValueSubject<[Photo], Never>
    let albumsSignal: CurrentValueSubject<[Album], Never>
    
    init(photosSignal: CurrentValueSubject<[Photo], Never>, albumsSignal: CurrentValueSubject<[Album], Never>) {
        self.photosSignal = photosSignal
        self.albumsSignal = albumsSignal
    }
    
    /// Fetches the albums for a specific author that we will use to filter out the photos results
    public func fetchAlbumsForGivenAuthor(id: String) {
        guard let url = URL(string: "\(baseUrl)albums?userId=\(id)") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let albums = try? JSONDecoder().decode([Album].self, from: data) else { return }
            self.albumsSignal.send(albums)
        }.resume()
    }
    
    public func fetchAllPhotos() {
        guard let url = URL(string: "\(baseUrl)photos") else { return }
        let urlSession = URLSession(configuration: .default)
        
        urlSession.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data,
                  let self = self,
                  let photos = try? JSONDecoder().decode([Photo].self, from: data) else { return }
            self.photosSignal.send(photos)
        }.resume()
    }
}
