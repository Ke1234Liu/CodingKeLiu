//
//  CustomCell.swift
//  KeLiuChallenge
//
//  Created by Ke Liu on 11/9/21.
//

import UIKit

class CustomCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    
    // MARK: - private properties
    private var cellImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var cellTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private var cellCommentsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - internal func
    func configureCell(title: String?, numComments: String?, data: Data?) {
        cellTitleLabel.text = title
        cellCommentsLabel.text = "Numbers of comments: \(numComments ?? "")"
        cellImageView.image = nil
        if let data = data {
            cellImageView.image = UIImage(data: data)
        }
    }
    
    // MARK: - private func
    private func setUpUI() {
        // adding views in stack view
        stackView.addArrangedSubview(cellTitleLabel)
        stackView.addArrangedSubview(cellImageView)
        stackView.addArrangedSubview(cellCommentsLabel)
        // adding stack view in main view
        contentView.addSubview(stackView)
        // setup constraint
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
    }
    
    // MARK: - override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
