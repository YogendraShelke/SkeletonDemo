//
//  Cell.swift
//  SkeletonDemo
//
//  Created by Yogendra Shelke on 1/21/20.
//  Copyright © 2020 Yogendra Shelke. All rights reserved.
//


import UIKit
import SkeletonView

class Cell: UITableViewCell {
    
    static let identifier = "Cell"
    static let size: CGFloat = 60
    static let margin: CGFloat = 20
    static let fontSize: CGFloat = 20
    
    var repo: Repo? {
        didSet {
            guard let repo = repo else {
                showLoading()
                return
            }
            hideLoading()
            avatarImageView.showImage(from: repo.avatar)
            titleLabel.text = repo.author
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Cell.fontSize, weight: .medium)
        label.isSkeletonable = true
        return label
    }()
    
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isSkeletonable = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(avatarImageView)
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Cell.margin).isActive = true
        avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: Cell.size).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: Cell.size).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Cell.margin).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width - Cell.margin * 2).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Cell.fontSize).isActive = true
        avatarImageView.layer.cornerRadius = Cell.size/2
        avatarImageView.clipsToBounds = true
    }
    
    func showLoading() {
        titleLabel.showAnimatedGradientSkeleton()
        avatarImageView.showAnimatedGradientSkeleton()
    }
    func hideLoading() {
        titleLabel.hideSkeleton()
        avatarImageView.hideSkeleton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

