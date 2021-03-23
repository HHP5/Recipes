//
//  TableViewCell.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {

    static let identifier = "MainPageCell"

    var cellModel: TableCellModelType? {
        willSet(cellModel) {
            guard let cellModel = cellModel else { return }

            nameLabel.text = cellModel.name
            descriptionLabel.text = cellModel.description
            
            if let image = cellModel.imageURL{
                
                imageFood.kf.indicatorType = .activity
                imageFood.kf.setImage(with: image)
                
            }
        }
    }
    //MARK: - UI Elements

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()

    private let imageFood: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(nameLabel)
        addSubview(imageFood)
        addSubview(descriptionLabel)

        setConstraint()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Constraints
    func setConstraint() {

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageFood.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -160).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20).isActive = true

        imageFood.translatesAutoresizingMaskIntoConstraints = false
        imageFood.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        imageFood.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 5).isActive = true
        imageFood.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        imageFood.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: imageFood.leadingAnchor, constant: -10).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true

    }

}



