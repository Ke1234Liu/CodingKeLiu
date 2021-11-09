//
//  KeLiuChallengeTests.swift
//  KeLiuChallengeTests
//
//  Created by Ke Liu on 11/9/21.
//

import XCTest
import Combine
@testable import KeLiuChallenge

class KeLiuChallengeTests: XCTestCase {
    
    private var fakeNetworkManager = FakeNetworkManager()
    private var viewModel: StoryViewModel!
    private var subscribers = Set<AnyCancellable>()

    override func setUpWithError() throws {
        viewModel = StoryViewModel(networkManager: fakeNetworkManager)
    }

    func testLoadDataSuccess() throws {
        // Given
        let expectation = XCTestExpectation(description: "sucess expectation")
        let data = try loadData(jsonName: "data")
        let response = try JSONDecoder().decode(Response.self, from: data)
        fakeNetworkManager.response = response
        
        // When
        viewModel
            .$items
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { stories in
                XCTAssertEqual(stories.count, 25)
                expectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.loadData()
        
        // Then
        wait(for: [expectation], timeout: 2)
    }
    
    private func loadData(jsonName: String) throws -> Data {
        let bundle = Bundle(for: KeLiuChallengeTests.self)
        guard let file = bundle.url(forResource: jsonName, withExtension: "json")
        else { fatalError("File \(jsonName) could not be loaded") }
        return try Data(contentsOf: file)
    }
}
