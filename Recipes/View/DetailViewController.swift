//
//  DetailViewController.swift
//  Test
//
//  Created by Екатерина Григорьева on 15.02.2021.
//

import UIKit

class DetailViewController: UIViewController {
    var detailModel: DetailViewModelType
    
    init(detailModel: DetailViewModelType) {
        self.detailModel = detailModel
        super.init(nibName: nil, bundle: nil)
        handleResult(detailModel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        buttonFieldView.delegate = self
        addSubviews()
        
    }
    
    private func handleResult(_ detailModel: DetailViewModelType) {
        
        startActivityIndicatorView()
        
        detailModel.setRecipeAttributes { [weak self] error in
            
            if let error = error {
                
                let alert = AlertService.alert(message: error.localizedDescription)
                self?.present(alert, animated: true)
                
                return
            }
                        
            self?.name.text = detailModel.name
            self?.difficulty.text = detailModel.difficulty
            self?.descriptionText.text = detailModel.description
            self?.instructionLabel.text = "Instruction: \n"
            self?.instructionText.text = detailModel.instruction
            self?.similarLabel.text = detailModel.hasSimilarRecipes ? "SIMILAR RECIPE:" : ""
            
            self?.collectionView.dataSource = self
            self?.buttonFieldView.dataSource = self
            
            self?.buttonFieldView.reloadData()
            self?.collectionView.reloadData()
            
            DispatchQueue.main.async { [weak self] in
                self?.setScrollConstraints()
                self?.stopActivityIndicatorView()
            }
        }
    }
    
    // MARK: - UI Elements
    
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
    
    private let activityView = UIActivityIndicatorView(style: .large)
    
    private var name: UILabel = {
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
    
    private let descriptionText: UILabel = {
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
    
    private let instructionText: UILabel = {
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

// MARK: - UITableView Delegate DataSource

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let numberOfButtons = detailModel.numberOfButtons  else { return 0 }
        
        buttonFieldView.rowHeight = 60
        let height = buttonFieldView.rowHeight * CGFloat(numberOfButtons)
        buttonFieldView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return numberOfButtons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = buttonFieldView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell
        
        guard let tableCell = cell else { return UITableViewCell() }
        
        let tableModel = detailModel.tableCellModel(for: indexPath.row)
        tableCell.cellModel = tableModel
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let similarRecipe = detailModel.similarRecipePressed(for: indexPath.row) else {return}
        let destinationVC = DetailViewController(detailModel: similarRecipe)
        navigationController?.pushViewController(destinationVC, animated: true)
        buttonFieldView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Collection Part

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let numberOfImages = detailModel.numberOfImages else { return 0 }
        return numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                      for: indexPath) as? CollectionViewCell
        
        guard let collectionCell = cell,
              let images = detailModel.images else { return UICollectionViewCell() }
        
        let cellViewModel = detailModel.collectionCellViewModel(for: images[indexPath.row])
        collectionCell.cellModel = cellViewModel
        
        return collectionCell
        
    }
    
}

// MARK: - Constrains and Subviews

extension DetailViewController {
    private func addSubviews() {
        addActivityAndScrollToView()
        addSubviewsToScrollView()
        setConstrains()
    }
    
    private func addActivityAndScrollToView() {
        view.addSubview(scroll)
        view.addSubview(activityView)
    }
    
    private func addSubviewsToScrollView() {
        scroll.addSubview(collectionView)
        scroll.addSubview(name)
        scroll.addSubview(descriptionText)
        scroll.addSubview(difficulty)
        scroll.addSubview(instructionLabel)
        scroll.addSubview(instructionText)
        scroll.addSubview(similarLabel)
        scroll.addSubview(buttonFieldView)
        scroll.addSubview(similarLabel)
    }
    
    private func startActivityIndicatorView() {
        activityView.isHidden = false
        activityView.startAnimating()
    }
    
    private func stopActivityIndicatorView() {
        activityView.stopAnimating()
        activityView.isHidden = true
    }
    
    private func setConstrains() {
        setActivityViewConstraints()
        setNameLabelConstraints()
        setDifficultyLabelConstraints()
        setCollectionViewConstraints()
        setDescriptionLabelConstraints()
        setInstructionLabelConstraints()
        setInstructionTextLabelConstraints()
        setSimilarLabelConstraints()
        setButtonFieldViewConstraints()
        
    }
    
    private func setActivityViewConstraints() {
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setScrollConstraints() {
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scroll.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        let height = descriptionText.frame.height +
            instructionLabel.frame.height +
            instructionText.frame.height +
            difficulty.frame.height +
            buttonFieldView.frame.height + 450
        
        scroll.contentSize = CGSize(width: view.frame.width, height: height)
    }
    
    private func setNameLabelConstraints() {
        name.heightAnchor.constraint(equalToConstant: 70).isActive = true
        name.topAnchor.constraint(equalTo: scroll.topAnchor, constant: -5).isActive = true
        name.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
    
    private func setDifficultyLabelConstraints() {
        difficulty.topAnchor.constraint(equalTo: name.bottomAnchor, constant: -10).isActive = true
        difficulty.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 15).isActive = true
    }
    
    private func setCollectionViewConstraints() {
        collectionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 0).isActive = true
        collectionView.widthAnchor.constraint(equalTo: scroll.widthAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: difficulty.bottomAnchor).isActive = true
    }
    
    private func setDescriptionLabelConstraints() {
        descriptionText.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        descriptionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        descriptionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
    
    private func setInstructionLabelConstraints() {
        instructionLabel.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 10).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
    }
    
    private func setInstructionTextLabelConstraints() {
        instructionText.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor).isActive = true
        instructionText.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        instructionText.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
    }
    
    private func setSimilarLabelConstraints() {
        similarLabel.topAnchor.constraint(equalTo: instructionText.bottomAnchor, constant: 10).isActive = true
        similarLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        similarLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    private func setButtonFieldViewConstraints() {
        buttonFieldView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        buttonFieldView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        buttonFieldView.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 10).isActive = true
        buttonFieldView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
    }
}
