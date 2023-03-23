//
//  HomeViewController.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import UIKit

protocol HomeViewControllerInterface: AnyObject {
    func configureVC()
    func reloadTable()
    func configureRefreshControl()
    func configureCamera()
}

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewViewModel()
    private let refreshControl = UIRefreshControl()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a task"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let tasksTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        searchController.searchResultsUpdater = self
 
    }
    
    
}

extension HomeViewController: HomeViewControllerInterface {
    
    func configureVC() {
        view.backgroundColor = .systemMint
        view.addSubview(tasksTableView)
        tasksTableView.frame = view.bounds
        
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        configureCamera()
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
        }
    }
    
    func configureRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
          refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
          tasksTableView.addSubview(refreshControl) // not required when using UITableViewController
       }
    @objc func refresh(_ sender: AnyObject) {
        viewModel.getTasks()
        refreshControl.endRefreshing()
    }
    
    func configureCamera() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(qrButtonTapped))
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
    @objc func qrButtonTapped(){
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        print(String(viewModel.numberOfRow()))
        return viewModel.numberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else { return UITableViewCell() }
        let singleModel = viewModel.setToSource(indexPath)
        cell.cellSetup((singleModel)!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text ?? ""
        
        let searchResults = viewModel.search(searchBar.text)
        viewModel.getSearchedItems(searchResults)
        self.reloadTable()
        
    }
}

extension HomeViewController: CameraHandleDelegate {
    func prepareQRScanningResult(_ text: String) {
        searchController.searchBar.text = text
    }
    
    
}
