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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .blue
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init has not implemented")
    }
}

extension MovieListTableViewCell {
    func setupViews(){
        self.addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }
}
