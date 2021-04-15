//
//  ViewController.swift
//  Test
//
//  Created by Екатерина Григорьева on 14.02.2021.
//

import UIKit

class RecipeListViewController: UIViewController {
    private var searchBar = UISearchBar()
    private var tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
	private var viewModel: RecipeListViewModelType!
    
	required convenience init(viewModel: RecipeListViewModelType) {
		self.init(nibName: nil, bundle: nil)
		
		self.viewModel = viewModel
		viewModel.fetchingRecipes()
		bindToViewModel()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setNavBar()
        setActivityIndicator()
    }
    
	private func bindToViewModel() {
		viewModel.didStartRequest = { [weak self] in
			self?.startActivityIndicator()
		}
		
		viewModel.didFinishRequest = { [weak self] in
			self?.stopActivityIndicator()
			self?.setTableView()
		}

		viewModel.didUpdateData = { [weak self]  in
			self?.tableView.reloadData()
		}

		viewModel.didReceiveError = { [weak self] error in

			let alert = AlertService.alert(message: error.localizedDescription)
			self?.present(alert, animated: true)

			return
		}
	}
	
    func setActivityIndicator() {
        view.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func startActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.rowHeight = 200
        
    }
    
    private func setNavBar() {
        navigationItem.title = "R E C I P E S"
        // Кнопка поиска
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(handleShowSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .black
        // Кнопка сортировки
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"),
                                                           style: .done, target: self,
                                                           action: #selector(handleShowSortItems))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    @objc func handleShowSortItems() {
        let alertController = UIAlertController(title: "Sort by", message: nil, preferredStyle: .actionSheet)
		let sortByDateAscending = UIAlertAction(title: RecipesSortedType.lastUpdateAscending.title,
                                                style: .default) { [weak self] _ in
            self?.viewModel.sortArray(by: .lastUpdateDescending)
            self?.tableView.reloadData()
        }
        let sortByDateDescending = UIAlertAction(title: RecipesSortedType.lastUpdateAscending.title,
                                                 style: .default) { [weak self] _ in
            self?.viewModel.sortArray(by: .lastUpdateAscending)
            self?.tableView.reloadData()
        }
        let sortByName = UIAlertAction(title: RecipesSortedType.name.title, style: .default) { [weak self] _ in
            self?.viewModel.sortArray(by: .name)
            self?.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(sortByDateAscending)
        alertController.addAction(sortByDateDescending)
        alertController.addAction(sortByName)
        alertController.addAction(cancel)
        alertController.pruneNegativeWidthConstraints()
        alertController.view.layoutIfNeeded()
        present(alertController, animated: true)
        
    }
    
    @objc func handleShowSearchBar() {
        searchBar.delegate = self
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = searchBar
        searchBar.tintColor = .black
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter something"
        searchBar.becomeFirstResponder()
    }
    
}

// MARK: - TableView DataSource and Delegate

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell
        guard let tableViewCell = cell else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.cellModel = cellViewModel
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let recipe = viewModel.didSelectRow(at: indexPath.row)
        let destinationVC = DetailViewController(detailModel: recipe)
        navigationController?.pushViewController(destinationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension RecipeListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchText = searchBar.text?.lowercased() {
            
            if searchText.isEmpty {
                viewModel.searchBarCancelButtonClicked()
                self.searchBar.endEditing(true)
                
            } else {
                
                viewModel.searchBarSearchButtonClicked(for: searchText)
                
            }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action: #selector(handleShowSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .black
        searchBar.showsCancelButton = false
        
        searchBar.text = nil
        
        viewModel.searchBarCancelButtonClicked()
        
        tableView.reloadData()
    }
    
}

// Решение проблемы с layout error для alertController
// (ссылка: https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints)

extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
