//
//  CurrencyPairViewModelTests.swift
//  TestRevolutTests
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import CoreData
@testable import TestRevolut

class CurrencyPairViewModelTests: XCTestCase {
    
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
        self.inMemoryObjectContext = self.setUpInMemoryManagedObjectContext()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCurencyPairVM() {
       let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
       currency1.name = "testCurrency1"
       currency1.code = "testCode1"
       currency1.imageName = "testPath1"
       
       let currency2 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
       currency2.name = "testCurrency2"
       currency2.code = "testCode2"
       currency2.imageName = "testPath2"
       
       let curencyPair = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.CurrencyPair.rawValue, into: inMemoryObjectContext) as! CurrencyPair
       curencyPair.baseCurrency = currency1
       curencyPair.destinationCurrency = currency2
       
       do {
           try inMemoryObjectContext.save()
       } catch {
           print (error.localizedDescription)
           XCTFail()
       }
        
        let currencyPairViewModelToTest: CurrencyPairViewModel = CurrencyPairViewModelImpl.init(currencyPair: curencyPair)
        
        XCTAssertEqual(currencyPairViewModelToTest.sourceCurrencySubtitle, "testCurrency1")
         XCTAssertEqual(currencyPairViewModelToTest.destinationCurrencySubtitle, "testCurrency2")
    }

   

}
