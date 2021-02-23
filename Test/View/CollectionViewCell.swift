//
//  CollectionViewCell.swift
//  Test
//
//  Created by Екатерина Григорьева on 16.02.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "DetailCollectionViewCell"

    var cellModel: CollectionCellModelType? {
        willSet(cellModel) {

            guard let url = cellModel?.url,
                let currentImage = cellModel?.currentImage,
                let totalCountImages = cellModel?.totalNumberImages
                else { return }
            imageFood.loadImageWithUrl(url)
            countImageLabel.isHidden = totalCountImages > 1 ? false : true
            countImageLabel.text = "\(currentImage) / \(totalCountImages)"
        }
    }
    //MARK: - UI Elements

    private var imageFood: ImageLoader = {
        let image = ImageLoader()
        image.contentMode = .scaleAspectFit
        return image
    }()

    let countImageLabel: UILabel = {
        let label = UILabel()

        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    //MARK: - Constraits and Subviews
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setSubviews() {
        contentView.addSubview(imageFood)
        contentView.addSubview(countImageLabel)

        imageFood.translatesAutoresizingMaskIntoConstraints = false
        imageFood.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageFood.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageFood.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        imageFood.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true

        countImageLabel.frame = CGRect(x: Int(contentView.frame.width) - 70, y: 0, width: 65, height: 30)
    }

}
