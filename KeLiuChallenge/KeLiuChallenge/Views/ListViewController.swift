//
//  ViewController.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    private let viewModel = StoryViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.prefetchDataSource = self
        tableview.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setupBinding()
    }
    
    // MARK:- private func
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        // configure constraint
        let safeArea = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
    
    private func setupBinding() {
        // binding to get data
        viewModel
            .$items
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        // biding to get image data
        viewModel
            .$updateRow
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
            .store(in: &subscribers)
        
        // load data from API
        viewModel.loadData()
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell
        else { return UITableViewCell() }
        
        let row = indexPath.row
        let title = viewModel.getTitle(at: row)
        let numComments = viewModel.getNumComments(at: row)
        let data = viewModel.getImage(by: row)
        cell.configureCell(title: title, numComments: numComments, data: data)
        cell.selectionStyle = .none
        return cell
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let rows = indexPaths.map{ $0.row }
        viewModel.loadMoreData(rowsDisplayed: rows)
    }
}
