//
//  MovieListTableViewCell.swift
//  MovieList
//
//  Created by Yasin Dalkilic on 29.07.2023.
//

import UIKit
import SnapKit

class MovieListTableViewCell: UITableViewCell {

    static let identifier = "MovieListTableViewCell"

    public let customImageView : UIImageView = {
        let customImage = UIImageView()
        customImage.image = UIImage(named: "clicked")
        customImage.contentMode = .scaleToFill
        customImage.layer.cornerRadius = 20
        customImage.layer.masksToBounds = true
        return customImage
    }()

    public let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    public let yearLabel : UILabel = {
        let label = UILabel()
        label.text = "Year"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

    public let typeLabel : UILabel = {
        let label = UILabel()
        label.text = "Type"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

    public let imdbLabel : UILabel = {
        let label = UILabel()
        label.text = "Imdb"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()

    private var verticalStackView: UIStackView!
    private var horizontalStackView: UIStackView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .darkGray

        setupVStackView()
        setupLayoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init has not implemented")
    }
}

extension MovieListTableViewCell {

    func setup() {
        self.addSubview(self.customImageView)

        customImageView.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }

    func setupVStackView(){
        self.verticalStackView = UIStackView(arrangedSubviews: [titleLabel, yearLabel, typeLabel, imdbLabel])
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 4
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false

        self.verticalStackView.layer.borderColor = UIColor.lightGray.cgColor
        self.verticalStackView.layer.borderWidth = 1.0
        self.verticalStackView.layer.cornerRadius = 12
    }


    func setupLayoutViews(){
        self.horizontalStackView = UIStackView()
        self.horizontalStackView.axis = .vertical
        self.horizontalStackView.spacing = 10

        self.addSubview(self.horizontalStackView)

        self.horizontalStackView.addArrangedSubview(self.customImageView)
        self.horizontalStackView.addArrangedSubview(self.verticalStackView)

        self.horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.customImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(80)
            make.top.equalTo(10)
            make.bottom.equalTo(10)
        }

        self.verticalStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.customImageView.snp.trailing).offset(20)
            make.top.equalTo(10)
            make.trailing.equalTo(10)
            make.bottom.equalTo(10)
        }
    }
}
