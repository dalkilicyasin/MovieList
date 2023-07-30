//
//  ViewController.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 28.07.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController, MovieListViewModelDelegate {
    func gamesListDownloadFinished() {
        tableView.reloadData()
    }


    var viewModel : MovieListViewModel? {
        didSet {
        
                tableView.reloadData()

        }
    }

    init(viewModel: MovieListViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder : NSCoder) {
        fatalError("initilation has not implemented")
    }

    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.rowHeight = 200
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
        viewModel?.fetchMovies()
        viewModel?.delegate = self
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.allMovies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as! MovieListTableViewCell
        cell.titleLabel.text = self.viewModel?.allMovies[indexPath.row].Title ?? ""
        cell.yearLabel.text = self.viewModel?.allMovies[indexPath.row].Year ?? ""
        cell.imdbLabel.text = self.viewModel?.allMovies[indexPath.row].imdbID ?? ""
        cell.typeLabel.text = self.viewModel?.allMovies[indexPath.row].`Type` ?? ""

        self.viewModel?.service.downloadImage(from: URL.init(string: self.viewModel?.allMovies[indexPath.row].Poster ?? "")!) { [weak self] (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.customImageView.image = UIImage.init(data: data)

                }
            }
        }
        return cell
    }
}

