//
//  ViewController.swift
//  SkeletonDemo
//
//  Created by Yogendra Shelke on 1/15/20.
//  Copyright © 2020 Yogendra Shelke. All rights reserved.
//

import UIKit
import SkeletonView

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
