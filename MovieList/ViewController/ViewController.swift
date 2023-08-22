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
        collectionView.reloadData()
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
        tableview.separatorColor = .white
        tableview.separatorStyle = .singleLine
        return tableview
    }()

    let cellWidth = (3 / 4) * UIScreen.main.bounds.width
    let cellHeight = (2 / 3.7) * UIScreen.main.bounds.width
    let spacing = (1 / 8) * UIScreen.main.bounds.width
    let cellSpacing = (1 / 1) * UIScreen.main.bounds.width

    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20
        layout.itemSize = .init(width: self.cellWidth, height: cellHeight)
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray
        collectionView.register(MovieListCollectionViewCell.self, forCellWithReuseIdentifier: MovieListCollectionViewCell.identifier)
        return collectionView
    }()

    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = .white
        searchController.searchBar.delegate = self
        return searchController
    }()

    private var activityIndicator = UIActivityIndicatorView()
    private var verticalStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.setupViews()
        viewModel?.fetchMovies()
        viewModel?.searchMovies(searchText: "star")
        viewModel?.delegate = self
        self.showActivityIndicator()

        navigationItem.searchController = self.searchController
    }
}

// - MARK: TableView
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.allMovies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as! MovieListTableViewCell
        cell.titleLabel.text = self.viewModel?.allMovies[indexPath.row].Title ?? ""
        cell.yearLabel.text = "Year :\(self.viewModel?.allMovies[indexPath.row].Year ?? "")"
        cell.imdbLabel.text = "ImdbID :\(self.viewModel?.allMovies[indexPath.row].imdbID ?? "")"
        cell.typeLabel.text = "Type :\(self.viewModel?.allMovies[indexPath.row].`Type` ?? "Movie")"

        self.viewModel?.service.downloadImage(from: URL.init(string: self.viewModel?.allMovies[indexPath.row].Poster ?? "")!) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.customImageView.image = UIImage.init(data: data)
                    self.viewModel?.allMovies[indexPath.row].imageData = UIImage.init(data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = self.viewModel?.allMovies[indexPath.row].imageData ?? UIImage()
        let description = self.viewModel?.allMovies[indexPath.row].Title ?? ""
        let year = self.viewModel?.allMovies[indexPath.row].Year ?? ""
        let imdb = self.viewModel?.allMovies[indexPath.row].imdbID ?? ""
        let viemodel = MovieListDetailViewModel()
        navigationController?.pushViewController(DetailViewController(imdbId: imdb, viewModel: viemodel, imageData: image), animated: false)
    }
}

// MARK: CollectionView
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.comedyMovies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.identifier, for: indexPath) as! MovieListCollectionViewCell

        cell.titleLabel.text = self.viewModel?.comedyMovies[indexPath.row].Title ?? ""
        cell.yearLabel.text = "Year :\(self.viewModel?.comedyMovies[indexPath.row].Year ?? "")"
        cell.imdbLabel.text = "ImdbID :\(self.viewModel?.comedyMovies[indexPath.row].imdbID ?? "")"
        cell.typeLabel.text = "Type :\(self.viewModel?.comedyMovies[indexPath.row].`Type` ?? "Movie")"

        self.viewModel?.service.downloadImage(from: URL.init(string: self.viewModel?.comedyMovies[indexPath.row].Poster ?? "")!) {(data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.customImageView.image = UIImage.init(data: data)
                    self.viewModel?.comedyMovies[indexPath.row].imageData = UIImage.init(data: data)
                    self.activityIndicator.stopAnimating()
                }
            }
        }

        cell.contentView.layer.cornerRadius = 30
        cell.contentView.layer.masksToBounds = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.viewModel?.comedyMovies[indexPath.row].imageData ?? UIImage()
        let description = self.viewModel?.comedyMovies[indexPath.row].Title ?? ""
        let year = self.viewModel?.comedyMovies[indexPath.row].Year ?? ""
        let imdb = self.viewModel?.comedyMovies[indexPath.row].imdbID ?? ""
        let viemodel = MovieListDetailViewModel()
        navigationController?.pushViewController(DetailViewController(imdbId: imdb, viewModel: viemodel, imageData: image), animated: false)
    }
}

// MARK: SearchBar
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            return
        }
        let filterString = searchController.searchBar.text

        if filterString == "" {
            viewModel?.searchMovies(searchText: "star")
        }else if filterString?.count ?? 0 > 2{
            viewModel?.searchMovies(searchText: filterString)
        }
    }
}

extension ViewController : UISearchBarDelegate {
}

// MARK: Indicator
extension ViewController {
    func showActivityIndicator(){
        if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            // Fallback on earlier versions
        }
        self.verticalStackView.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = view.center
        self.activityIndicator.hidesWhenStopped = true
    }
}

// MARK: StackView
extension ViewController {
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(1)
            make.height.equalToSuperview().multipliedBy(0.7)
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.leading.equalToSuperview().offset(1)
            make.trailing.equalToSuperview().offset(1)
            make.bottom.equalToSuperview().offset(20)
        }
    }
}

