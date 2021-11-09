//
//  NetworkManager.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import Foundation
import Combine

class NetworkManager: NetworkProtocol {
    
    private let session = URLSession.shared
    
    func getImageData(from url: String) -> AnyPublisher<Data, NetworkError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError{ error in NetworkError.other(error) }
            .eraseToAnyPublisher()
    }
    
    func getResponse(from url: String) -> AnyPublisher<Response, NetworkError> {
        
        guard let url = URL(string: url) else {
            return Fail(error: NetworkError.badURL).eraseToAnyPublisher()
        }
        
        // printing in console the url
        print(url.absoluteURL)
        
        return session
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError{ error in NetworkError.other(error) }
            .eraseToAnyPublisher()
    }
}
