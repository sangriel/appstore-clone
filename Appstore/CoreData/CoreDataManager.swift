//
//  CoreDataManager.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/19.
//

import Foundation
import CoreData
import RxSwift


protocol CoreDataManagerDelegate {
    func getDataList() -> [SearchWordModel]
    func addData(searchWord : String)
    func isEntityDuplicated(dataList : [SearchWordModel], searchWord : String) -> Bool
}

class CoreDataManager {
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SearchList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
}
extension CoreDataManager : CoreDataManagerDelegate {
    
    func getDataList() -> [SearchWordModel] {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SearchList")
        var dataList : [SearchWordModel] = []
        do {
            let rawData = try managedContext.fetch(fetchRequest)
            for value in rawData {
                dataList.append(SearchWordModel(keywords: value.value(forKey: "keywords") as! String))
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return dataList
    }
    
    func addData(searchWord: String) {
        if searchWord == "" {
            return
        }
        let managedContext = self.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SearchList", in: managedContext)!
        let newData = NSManagedObject(entity: entity, insertInto: managedContext)
        newData.setValue(searchWord, forKeyPath: "keywords")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func isEntityDuplicated(dataList : [SearchWordModel], searchWord : String) -> Bool {
       return dataList.contains(where: { $0.keywords == searchWord })
    }
}
