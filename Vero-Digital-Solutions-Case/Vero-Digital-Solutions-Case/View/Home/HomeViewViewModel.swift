//
//  HomeViewViewModel.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import Foundation

protocol HomeViewViewModelInteface {
    var view: HomeViewControllerInterface? { get set}
    
    func viewDidLoad()
    func getTasks()
    func search(_ searchText: String?) -> [ItemsModelElement]?
    func getSearchedItems(_ model: [ItemsModelElement]?)
    func numberOfRow() -> Int
    func setToSource(_ indexPath: IndexPath)-> ItemsModelElement?
    func savingDatasToDatabase()
}

final class HomeViewViewModel {

    weak var view: HomeViewControllerInterface?
    var tasks: [ItemsModelElement]? = []
    var filteredTasks: [ItemsModelElement]? = []

}

extension HomeViewViewModel: HomeViewViewModelInteface {

    func viewDidLoad() {
        getTasks()
        view?.configureVC()
        view?.configureRefreshControl()

    }
    
    func getTasks() {
        NetworkService.shared.getTasks { [weak self] tasks, error in
            self?.tasks = tasks
            DispatchQueue.main.async {
                  self?.savingDatasToDatabase()
                self?.view?.reloadTable()
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
        }

        
    }
    func search(_ keyword: String?) -> [ItemsModelElement]? {
        let searchResults = tasks?.filter{$0.task?.contains(keyword ?? "") ?? false ||
            $0.title?.contains(keyword ?? "") ?? false ||
            $0.descriptionn?.contains(keyword ?? "") ?? false ||
            $0.wageType?.contains(keyword ?? "") ?? false ||
            $0.parentTaskID?.contains(keyword ?? "") ?? false ||
            $0.businessUnit?.contains(keyword ?? "") ?? false
        }
        return searchResults
    }

    func getSearchedItems(_ model: [ItemsModelElement]?) {
        self.filteredTasks = model
        
    }
    
    func numberOfRow() -> Int {
        if (self.filteredTasks?.count == 0) {
            return self.tasks?.count ?? 10
        } else {
            return self.filteredTasks?.count ?? 10
        }
        view?.reloadTable()
        
    }
    
    func setToSource(_ indexPath: IndexPath) -> ItemsModelElement? {
        if (self.filteredTasks?.count == 0) {
            return tasks?[indexPath.item]
        }
        return filteredTasks?[indexPath.item]
        
        view?.reloadTable()
        
    }
    
    func savingDatasToDatabase() {
        let newItems = DataPersistenceManager.shared.downloadTitle(with: tasks!)
        self.tasks = newItems
        
        
        
    }
    
}
