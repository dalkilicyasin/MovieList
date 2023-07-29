//
//  ViewController.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 28.07.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let viewModel : MovieListViewModel

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder : NSCoder) {
        fatalError("initilation has not implemented")
    }

    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.rowHeight = 100
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableview.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .systemBackground
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        tableView.reloadData()
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as! MovieListTableViewCell
        return cell
    }
}

