//
//  CurrencyViewModelTests.swift
//  TestRevolutTests
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import CoreData
@testable import TestRevolut

class CurrencyViewModelTests: XCTestCase {
    
    var inMemoryObjectContext: NSManagedObjectContext!
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    override func setUp() {
        inMemoryObjectContext = setUpInMemoryManagedObjectContext()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurrencyModel() {
        let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency1.name = "testCurrency1"
        currency1.code = "testCode1"
        currency1.imageName = "testPath1"
        
        let currencyVM = CurrencyViewModelImpl(currency: currency1)
        
        XCTAssertEqual(currencyVM.currencyCode, currency1.code)
        XCTAssertEqual(currencyVM.currencyName, currency1.name)
        XCTAssertEqual(currencyVM.imageName, currency1.imageName)
    }

}
