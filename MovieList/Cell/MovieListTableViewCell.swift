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

    public var customImageView : UIImageView = {
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
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

    func setupVStackView(){
        self.verticalStackView = UIStackView(arrangedSubviews: [titleLabel, yearLabel, typeLabel, imdbLabel])
        self.verticalStackView.axis = .vertical
        self.verticalStackView.spacing = 20
    }

    func setupLayoutViews(){
        self.horizontalStackView = UIStackView()
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.spacing = 30

        self.addSubview(self.horizontalStackView)

        self.horizontalStackView.addArrangedSubview(self.customImageView)
        self.horizontalStackView.addArrangedSubview(self.verticalStackView)

        self.horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }

        self.customImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.75)
            make.leading.equalTo(10)
            make.top.equalTo(16)
        }

        self.verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
