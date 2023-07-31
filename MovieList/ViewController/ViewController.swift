//
//  ViewController.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 28.07.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController, MovieListViewModelDelegate {

    func moviesListDownloadFinished() {
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
        tableview.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = .clear
        return tableview
    }()

    let cellWidth = (3 / 4) * UIScreen.main.bounds.width
    let spacing = (1 / 8) * UIScreen.main.bounds.width
    let cellSpacing = (1 / 16) * UIScreen.main.bounds.width

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: self.spacing, bottom: 0, right: self.cellSpacing)
        layout.minimumLineSpacing = 0
        layout.itemSize = .init(width: self.cellWidth, height: self.cellWidth)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        return collectionView
    }()

    private var activityIndicator = UIActivityIndicatorView()
    private var searchController = UISearchController()
    private var verticalStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .clear
        self.setupViews()
        viewModel?.fetchMovies()
        viewModel?.delegate = self
        self.showActivityIndicator()

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    // - MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.allMovies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as! MovieListTableViewCell
        cell.titleLabel.text = self.viewModel?.allMovies[indexPath.row].Title ?? ""
        cell.yearLabel.text = self.viewModel?.allMovies[indexPath.row].Year ?? ""
        cell.imdbLabel.text = self.viewModel?.allMovies[indexPath.row].imdbID ?? ""
        cell.typeLabel.text = self.viewModel?.allMovies[indexPath.row].`Type` ?? ""

        self.viewModel?.service.downloadImage(from: URL.init(string: self.viewModel?.allMovies[indexPath.row].Poster ?? "")!) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.customImageView.image = UIImage.init(data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        return cell
    }
}

extension ViewController : UICollectionViewDataSource {
    // - MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.allMovies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as! MovieListCollectionViewCell

        cell.titleLabel.text = self.viewModel?.allMovies[indexPath.row].Title ?? ""
        cell.yearLabel.text = self.viewModel?.allMovies[indexPath.row].Year ?? ""
        cell.imdbLabel.text = self.viewModel?.allMovies[indexPath.row].imdbID ?? ""
        cell.typeLabel.text = self.viewModel?.allMovies[indexPath.row].`Type` ?? ""

        self.viewModel?.service.downloadImage(from: URL.init(string: self.viewModel?.allMovies[indexPath.row].Poster ?? "")!) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.customImageView.image = UIImage.init(data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        return cell
    }
}

extension ViewController : UISearchResultsUpdating {
    // - MARK: SearchBar
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        let filterString = searchController.searchBar.text

        if filterString == "" {
            viewModel?.fetchMovies()
        }else if filterString?.count ?? 0 > 2{
            viewModel?.searchMoview(searchText: filterString)
        }
    }
}

extension ViewController {
    // - MARK: Indicator
    func showActivityIndicator(){
        if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            // Fallback on earlier versions
        }
        tableView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = view.center
        self.activityIndicator.hidesWhenStopped = true
    }
}

extension ViewController {
    // - MARK: StackView
    func setupViews(){
        self.verticalStackView = UIStackView()
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 30

        view.addSubview(self.verticalStackView)

        self.verticalStackView.addArrangedSubview(self.tableView)
        self.verticalStackView.addArrangedSubview(self.collectionView)
        
        self.verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(1)
            make.height.equalToSuperview().multipliedBy(0.75)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(1)
            make.bottom.equalToSuperview().offset(1)
        }
    }
}

