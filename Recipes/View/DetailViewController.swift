//
//  DetailViewController.swift
//  Test
//
//  Created by Екатерина Григорьева on 15.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailModel: DetailViewModelType? {
        willSet(detailModel) {
            guard let detailModel = detailModel else {return}
            
            startActivityIndicatorView(for: activityViewForEntiryPage)
            
            detailModel.setRecipeAttributes { [weak self] (error) in
                
                guard error == nil else{
                    let alert = AlertService.alert(message: error!.localizedDescription)
                    self?.present(alert, animated: true)
                    return
                }
                
                self?.nameLabel.text = detailModel.name
                self?.difficulty.text = detailModel.difficulty
                self?.descriptionLabel.text = detailModel.description
                self?.instructionLabel.text = "Instruction: \n"
                self?.instructionTextLabel.text = detailModel.instruction
                self?.similarLabel.text = detailModel.similarLabel
                
                self?.collectionView.dataSource = self
                self?.buttonFieldView.dataSource = self
                
                self?.buttonFieldView.reloadData()
                self?.collectionView.reloadData()
                
                DispatchQueue.main.async { [weak self] in
                    
                    let height = self!.descriptionLabel.frame.height + self!.instructionLabel.frame.height + self!.instructionTextLabel.frame.height + self!.difficulty.frame.height + self!.buttonFieldView.frame.height + 450
                    
                    self?.scroll.contentSize = CGSize(width: self!.view.frame.width, height: height)
                }
                self?.stopActivityIndicatorView(for: self!.activityViewForEntiryPage)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        buttonFieldView.delegate = self
        addSubviews()
        
    }
    
    
    //MARK: - UI Elements
    private var buttonFieldView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    private var scroll: UIScrollView = {
        var scroll = UIScrollView(frame: UIScreen.main.bounds)
        scroll.backgroundColor = .white
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.layoutIfNeeded()
        return scroll
    }()
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private let activityViewForEntiryPage = UIActivityIndicatorView(style: .large)
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.tintColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let difficulty: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .italicSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let similarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
//MARK: - UITableView Delegate DataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailModel = detailModel, let numberOfButtons = detailModel.numberOfButtons  else { return 0 }
        buttonFieldView.rowHeight = 60
        let height = buttonFieldView.rowHeight * CGFloat(numberOfButtons)
        buttonFieldView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return numberOfButtons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = buttonFieldView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell
        
        guard let tableCell = cell,
              let detailModel = detailModel else { return UITableViewCell() }
        
        let tableModel = detailModel.tableCellModel(for: indexPath.row)
        tableCell.cellModel = tableModel
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = DetailViewController()
        
        guard let detailModel = detailModel else {
            detailModelError()
            return
        }
        
        detailModel.similarRecipePressed(for: indexPath.row) { [weak self] (recipe) in
            
            destinationVC.detailModel = recipe
            self?.navigationController?.pushViewController(destinationVC, animated: true)
            self?.buttonFieldView.deselectRow(at: indexPath, animated: true)
            
        }
    }
    
    private func detailModelError(){
        let alert = AlertService.alert(message: "A critical error occurred, data is lost")
        present(alert, animated: true, completion: nil)
    }
    
}


//MARK: - Collection Part

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let detailModel = detailModel else { return 0 }
        
        return detailModel.numberOfImages!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell
        
        guard let collectionCell = cell, let detailModel = detailModel else { return UICollectionViewCell() }
        
        let cellViewModel = detailModel.collectionCellViewModel(for: detailModel.images![indexPath.row])
        collectionCell.cellModel = cellViewModel
        
        return collectionCell
        
    }
    
}

//MARK: - Constrains and Subviews

extension DetailViewController {
    
    private func addSubviews() {
        view.addSubview(scroll)
        view.addSubview(activityViewForEntiryPage)
        
        scroll.addSubview(collectionView)
        scroll.addSubview(nameLabel)
        scroll.addSubview(descriptionLabel)
        scroll.addSubview(difficulty)
        scroll.addSubview(instructionLabel)
        scroll.addSubview(instructionTextLabel)
        scroll.addSubview(similarLabel)
        scroll.addSubview(buttonFieldView)
        scroll.addSubview(similarLabel)
        
        setConstrains()
    }
    
    private func startActivityIndicatorView(for activity: UIActivityIndicatorView) {
        activity.isHidden = false
        activity.startAnimating()
    }
    
    private func stopActivityIndicatorView(for activity: UIActivityIndicatorView) {
        activity.stopAnimating()
        activity.isHidden = true
    }
    
    
    private func setConstrains() {
        activityViewForEntiryPage.translatesAutoresizingMaskIntoConstraints = false
        activityViewForEntiryPage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityViewForEntiryPage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scroll.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        nameLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        nameLabel.topAnchor.constraint(equalTo: scroll.topAnchor, constant: -5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        difficulty.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -10).isActive = true
        difficulty.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 15).isActive = true
        
        collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 0).isActive = true
        collectionView.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: difficulty.bottomAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        instructionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        instructionTextLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor).isActive = true
        instructionTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        instructionTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        similarLabel.topAnchor.constraint(equalTo: instructionTextLabel.bottomAnchor, constant: 10).isActive = true
        similarLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        similarLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        buttonFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonFieldView.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 10).isActive = true
        buttonFieldView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
        
    }
}
