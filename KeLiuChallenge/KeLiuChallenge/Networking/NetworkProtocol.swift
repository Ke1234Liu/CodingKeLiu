//
//  NetworkProtocol.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import Foundation
import Combine

enum URLs {
    static private let urlBase = "https://www.reddit.com/.json"
    static let keyAfter = "$AFTER_KEY"
    static let dataURL = "\(urlBase)?after=\(keyAfter)"
}

enum NetworkError: Error {
    case badURL
    case other(Error)
}

protocol NetworkProtocol {
    func getImageData(from url: String) -> AnyPublisher<Data, NetworkError>
    func getResponse(from url: String) -> AnyPublisher<Response, NetworkError>
}
