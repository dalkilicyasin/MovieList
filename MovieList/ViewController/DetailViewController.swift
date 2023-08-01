//
//  DetailViewController.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 31.07.2023.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

    let imageMovie : UIImageView = {
        let imageMovie = UIImageView()
        imageMovie.image = UIImage(named: "clicked")
        return imageMovie
    }()

    let labelDescription : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .blue
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        return descriptionLabel
    }()

    let labelYear : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        return descriptionLabel
    }()

    let labelReleaseDate : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        return descriptionLabel
    }()

    let labelGenre : UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        return descriptionLabel
    }()

    let labelDetail : UITextView = {
        let descriptionLabel = UITextView()
        descriptionLabel.font = UIFont(name: "ArialMT", size: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .black
        descriptionLabel.sizeToFit()
        return descriptionLabel
    }()

    let scrollView : UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.alwaysBounceHorizontal = false
        return scrollview
    }()

    let stackView : UIStackView = {
        let stackView = UIStackView()

        return stackView
    }()

    let imageData : UIImage?
    var viewModel : MovieListDetailViewModel?
    let imdbID : String?

    private var activityIndicator = UIActivityIndicatorView()

    init( imdbId: String, viewModel : MovieListDetailViewModel?, imageData : UIImage  ) {
        self.imdbID = imdbId
        self.viewModel = viewModel
        self.imageData = imageData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageMovie)
        view.addSubview(labelDescription)
        view.addSubview(labelYear)
        view.addSubview(labelGenre)
        view.addSubview(labelReleaseDate)
        view.addSubview(labelDetail)
        view.addSubview(scrollView)
        view.addSubview(stackView)

        self.scrollView.addSubview(stackView)
        stackView.axis = .vertical
        self.stackView.addArrangedSubview(labelDetail)

        self.imageMovie.image = imageData

        viewModel?.fetchMoviewDetail(imdbId: self.imdbID ?? "")
        viewModel?.delegate = self

        self.showActivityIndicator()
        
        imageConstraint()
    }

    func imageConstraint(){
        self.imageMovie.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(200)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }

        self.labelDescription.snp.makeConstraints { make in
            make.top.equalTo(self.imageMovie.snp.bottom).offset(20)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(300)
        }

        self.labelYear.snp.makeConstraints { make in
            make.top.equalTo(self.labelDescription.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }

        self.labelGenre.snp.makeConstraints { make in
            make.top.equalTo(self.labelYear.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }

        self.labelReleaseDate.snp.makeConstraints { make in
            make.top.equalTo(self.labelGenre.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.labelReleaseDate.snp.bottom)
            make.width.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(10)
        }

        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }

        self.labelDetail.snp.makeConstraints { make in
            make.width.equalTo(self.stackView.snp.width)
            make.height.equalTo(400)
        }
    }
}

extension DetailViewController : MovieListDetailViewModelDelegate {
    func moviesListDownloadFinished() {
        self.labelDescription.text = "Title :\(viewModel?.movieDetail.Title ?? "")\nActors :\(viewModel?.movieDetail.Actors ?? "")\nRunTime :\(viewModel?.movieDetail.Runtime ?? "")\nActors :\(viewModel?.movieDetail.Actors ?? "")\nDirector :\(viewModel?.movieDetail.Director ?? "")\nWriter :\(viewModel?.movieDetail.Writer ?? "")\nLanguage :\(viewModel?.movieDetail.Language ?? "")\nMetaScore :\(viewModel?.movieDetail.Metascore ?? "")\nimdbRating:\(viewModel?.movieDetail.imdbRating ?? "")\nimdbVote :\(viewModel?.movieDetail.imdbVotes ?? "")\nDVD :\(viewModel?.movieDetail.DVD ?? "")\nBoxoffice :\(viewModel?.movieDetail.BoxOffice ?? "")"
        self.labelReleaseDate.text = "Released :\(viewModel?.movieDetail.Released ?? "")"
        self.labelGenre.text = "Type :\(viewModel?.movieDetail.Genre ?? "")"
        self.labelYear.text = "Year :\(viewModel?.movieDetail.Year ?? "")"
        self.labelDetail.text = "\(viewModel?.movieDetail.Plot ?? "")"
        self.activityIndicator.stopAnimating()
    }
}

// MARK: Indicator
extension DetailViewController {
    func showActivityIndicator(){
        if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = view.center
        self.activityIndicator.hidesWhenStopped = true
    }
}


