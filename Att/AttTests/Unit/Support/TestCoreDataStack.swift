//
//  TestCoreDataStack.swift
//  Att
//
//  Created by 황정현 on 8/12/25.
//

import CoreData
import XCTest

final class TestCoreDataStack {
    let container: NSPersistentCloudKitContainer

    init(modelName: String = "Att", bundle: Bundle = .main) {
        let testBundle = Bundle(for: type(of: self))
        guard let modelURL = testBundle.url(forResource: modelName, withExtension: "momd")
                ?? bundle.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            XCTFail("Core Data model(\(modelName)) not found")
            fatalError()
        }

        container = NSPersistentCloudKitContainer(name: modelName, managedObjectModel: model)
        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        desc.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [desc]

        container.loadPersistentStores { _, error in
            if let error = error { fatalError("Load store error: \(error)") }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
