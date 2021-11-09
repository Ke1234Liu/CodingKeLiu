//
//  StoryViewModel.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import Foundation
import Combine

class StoryViewModel {
    
    // internal properties and funcs
    var count: Int { items.count }
    func getTitle(at row: Int) -> String? { items[row].title }
    func getNumComments(at row: Int) -> String? { "\(items[row].numComments)" }
    
    // publishers
    @Published private(set) var items = [Story]()
    @Published private(set) var updateRow = 0
    
    // private properties
    private let networkManager: NetworkProtocol
    private var cache = [String: Data]()
    private var afterString = ""
    private var isUpdating = false
    private var subscribers = Set<AnyCancellable>()
    
    // init
    init(networkManager: NetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // internal func
    func loadData() {
        isUpdating = true
        let url = URLs.dataURL.replacingOccurrences(of: URLs.keyAfter, with: afterString)
        networkManager
            .getResponse(from: url)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isUpdating = false
                case .failure(let error):
                    // printing error in console
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                let stories = response.data.children.map{ $0.data }
                self?.items.append(contentsOf: stories)
                self?.afterString = response.data.after
            }
            .store(in: &subscribers)
    }
    
    func getImage(by row: Int) -> Data? {
        let item = items[row]
        
        guard let url = item.thumbnail, url.contains("https://") // verifying if it is an url
        else { return nil }
        
        // verifying if the image is in cache
        if let data = cache[url] { return data }
        
        // download image
        networkManager
            .getImageData(from: url)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // print error in console
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                self?.cache[url] = data
                self?.updateRow = row
            }
            .store(in: &subscribers)

        return nil
    }
    
    func loadMoreData(rowsDisplayed rows: [Int]) {
        let lastRow = items.count - 1
        if rows.contains(lastRow) && !isUpdating {
            loadData()
        }
    }
    
}

