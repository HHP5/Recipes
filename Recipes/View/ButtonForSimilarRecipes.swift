//
//  ButtonForSimilarRecipes.swift
//  Test
//
//  Created by Екатерина Григорьева on 19.02.2021.
//

import Foundation
import UIKit


class ButtonCell: UITableViewCell {
    static let identifier = "ButtonForSimilarRecipesCell"

    var cellModel: ButtonCellModelType? {
        willSet(cellModel) {
            guard let cellModel = cellModel else { return }

            similarRecipeNameLabel.text = cellModel.name
        }
    }

    let similarRecipeNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.8289779425, green: 0.8045935631, blue: 0.8048815131, alpha: 1)
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(similarRecipeNameLabel)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        similarRecipeNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        similarRecipeNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        similarRecipeNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        similarRecipeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
        similarRecipeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    }
}
