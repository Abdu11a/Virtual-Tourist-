//
//  ControlData.swift
//  Virtual Tourist
//
//  Created by Abdulla Aseed on 15/03/1441 AH.
//  Copyright © 1441 Abdulla Alsahli. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class ControlData {
    let persistentContainer: NSPersistentContainer
  
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    static func shared() -> ControlData {
        struct Singleton {
            static var shared = ControlData(modelName: "Virtual_Tourist")
        }
        return Singleton.shared
    }
}
extension ControlData {
    func fetchPin(_ predicate: NSPredicate, entityName: String, sorting: NSSortDescriptor? = nil) throws -> Pin? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let pin = (try viewContext.fetch(fr) as! [Pin]).first else {
            return nil
        }
        return pin
    }
    
}
