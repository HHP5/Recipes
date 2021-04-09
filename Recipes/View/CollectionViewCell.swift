//
//  CollectionViewCell.swift
//  Test
//
//  Created by Екатерина Григорьева on 16.02.2021.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "DetailCollectionViewCell"

    var cellModel: CollectionCellModelType? {
        willSet(cellModel) {

            guard let imageURL = cellModel?.imageURL,
                let currentImageIndex = cellModel?.currentImageIndex,
                let totalCountImages = cellModel?.totalNumberImages
                else { return }
            
            imageFood.kf.indicatorType = .activity
            imageFood.kf.setImage(with: imageURL)
            imageFood.contentMode = .scaleAspectFit
            
            countImageLabel.isHidden = totalCountImages > 1 ? false : true
            countImageLabel.text = "\(currentImageIndex) / \(totalCountImages)"
        }
    }
    // MARK: - UI Elements

    private var imageFood = UIImageView() 

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
    
    // MARK: - Constraits and Subviews
    
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

        setImageFoodConstraint()

        countImageLabel.frame = CGRect(x: Int(contentView.frame.width) - 70, y: 0, width: 65, height: 30)
    }
    
    private func setImageFoodConstraint() {
        imageFood.translatesAutoresizingMaskIntoConstraints = false
        imageFood.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageFood.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageFood.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
        imageFood.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50).isActive = true
    }

}
