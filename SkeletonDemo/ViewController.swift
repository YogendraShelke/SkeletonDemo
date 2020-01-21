//
//  ViewController.swift
//  SkeletonDemo
//
//  Created by Yogendra Shelke on 1/15/20.
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

class ViewController: UIViewController {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var data = [Repo]()
    var showActivity = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
        Service.shared.getData {[weak self] data in
            self?.data = data
            self?.showActivity = false
            self?.tableView.reloadData()
        }
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        showActivity ? 20 : data.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        Cell.identifier
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.repo = showActivity ? nil : data[indexPath.row]
        return cell
    }
}

struct Repo: Decodable {
    let name, avatar, author: String
}

typealias completionHandler = ([Repo]) -> Void

class Service {
    static let shared = Service()
    private init() { }
    func getData(onSuccess: @escaping completionHandler) {
        let url = URL(string: "https://github-trending-api.now.sh/repositories?language=swift&since=weekly")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                guard let data = data else {
                    onSuccess([])
                    return
                }
                let list = try! JSONDecoder().decode([Repo].self, from: data)
                onSuccess(list)
            }
        }.resume()
    }
}

extension UIImageView {
    func showImage(from url: String) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
