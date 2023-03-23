//
//  DataPersistenceManager.swift
//  Vero-Digital-Solutions-Case
//
//  Created by Ali Görkem Aksöz on 23.03.2023.
//

import UIKit
import CoreData

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    private init () {}
    
    func downloadTitle(with model: [ItemsModelElement]) -> [ItemsModelElement]{
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "TaskItems", into: context)
        
        for item in model {
            newItem.setValue(item.task, forKey: "task")
            newItem.setValue(item.title, forKey: "title")
            newItem.setValue(item.descriptionn, forKey: "descriptionn")
            newItem.setValue(item.sort, forKey: "sort")
            newItem.setValue(item.wageType, forKey: "wageType")
            newItem.setValue(item.businessUnitKey, forKey: "businessUnitKey")
            newItem.setValue(item.businessUnit, forKey: "businessUnit")
            newItem.setValue(item.parentTaskID, forKey: "parentTaskID")
            newItem.setValue(item.preplanningBoardQuickSelect, forKey: "preplanningBoardQuickSelect")
            newItem.setValue(item.colorCode, forKey: "colorCode")
            newItem.setValue(item.workingTime, forKey: "workingTime")
            newItem.setValue(item.isAvailableInTimeTrackingKioskMode, forKey: "isAvailableInTimeTrackingKioskMode")
        }
        
        do {
            try context.save()
            print("Data saved")
            print(model.count)
            return model
        } catch  {
            print("There is a error while a saving data")
        }
        return []
    }
    
}

