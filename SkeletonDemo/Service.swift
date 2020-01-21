//
//  Service.swift
//  SkeletonDemo
//
//  Created by Yogendra Shelke on 1/21/20.
//  Copyright © 2020 Yogendra Shelke. All rights reserved.
//

import UIKit

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
