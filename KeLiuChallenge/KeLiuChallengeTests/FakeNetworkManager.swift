//
//  FakeNetworkManager.swift
//  KeLiuChallengeTests
//
//  Created by Ke Liu on 11/9/21.
//

import XCTest
import Combine
@testable import KeLiuChallenge

class FakeNetworkManager: NetworkProtocol {
    
    var data: Data?
    var response: Response?
    var error: Error?
    
    func getImageData(from url: String) -> AnyPublisher<Data, NetworkError> {
        
        if let error = error {
            return Fail(error: NetworkError.other(error)).eraseToAnyPublisher()
        }
        
        if let data = data {
            return CurrentValueSubject<Data, NetworkError>(data).eraseToAnyPublisher()
        }
        
        fatalError()
    }
    
    func getResponse(from url: String) -> AnyPublisher<Response, NetworkError> {
        
        if let error = error {
            return Fail(error: NetworkError.other(error)).eraseToAnyPublisher()
        }
        
        if let response = response {
            return CurrentValueSubject<Response, NetworkError>(response).eraseToAnyPublisher()
        }
        
        fatalError()
    }
    
    
}

