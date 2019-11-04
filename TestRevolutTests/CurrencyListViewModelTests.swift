//
//  CurrencyListViewModelTests.swift
//  TestRevolutTests
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import CoreData
@testable import TestRevolut

class CurrencyListViewModelTests: XCTestCase {
    
    var inMemoryObjectContext: NSManagedObjectContext!
    var currencyListVMInstance: CurrencyListViewModel!
    
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
        currencyListVMInstance = CurrencyListViewModelImpl.getInstance(dataContext: inMemoryObjectContext)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testGetCurrencies() {
        let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency1.name = "testCurrency1"
        currency1.code = "testCode1"
        currency1.imageName = "testPath1"
        
        let currency2 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency2.name = "testCurrency2"
        currency2.code = "testCode2"
        currency2.imageName = "testPath2"
        
        do {
            try inMemoryObjectContext.save()
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
        // Create an expectation
        let expectation = self.expectation(description: "fetching")
        
        do {
            try self.currencyListVMInstance.getCurrencies(shouldExcludeExistingPairs: false) {
                
                expectation.fulfill()
            }
        } catch let error{
            print (error.localizedDescription)
            XCTFail()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(self.currencyListVMInstance.getNumberOfCurrencies(), 2)
    }
    
    func testGetCurrencyForCellAtIndex() {
        let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency1.name = "testCurrency1"
        currency1.code = "testCode1"
        currency1.imageName = "testPath1"
        
        let currency2 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency2.name = "testCurrency2"
        currency2.code = "testCode2"
        currency2.imageName = "testPath2"
        
        do {
            try inMemoryObjectContext.save()
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
        
        // Create an expectation
        let expectation = self.expectation(description: "fetching")
        
        do {
            try self.currencyListVMInstance.getCurrencies(shouldExcludeExistingPairs: false) {
                
                expectation.fulfill()
            }
        } catch let error{
            print (error.localizedDescription)
            XCTFail()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(self.currencyListVMInstance.getCurrencyForCellAtIndex(0)?.currencyCode, currency1.code)
        XCTAssertEqual(self.currencyListVMInstance.getCurrencyForCellAtIndex(1)?.currencyCode, currency2.code)
    }
    
    func testGetNumberOfCurrencies() {
        let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency1.name = "testCurrency1"
        currency1.code = "testCode1"
        currency1.imageName = "testPath1"
        
        let currency2 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency2.name = "testCurrency2"
        currency2.code = "testCode2"
        currency2.imageName = "testPath2"
        
        do {
            try inMemoryObjectContext.save()
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
        // Create an expectation
        let expectation = self.expectation(description: "fetching")
        
        do {
            try self.currencyListVMInstance.getCurrencies(shouldExcludeExistingPairs: false) {
                
                expectation.fulfill()
            }
        } catch let error{
            print (error.localizedDescription)
            XCTFail()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(self.currencyListVMInstance.getNumberOfCurrencies(), 2)
    }

}
