//
//  CoreDataTests.swift
//  TestRevolutTests
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import XCTest
import CoreData
@testable import TestRevolut

class CoreDataTests: XCTestCase {
    
    var inMemoryObjectContext: NSManagedObjectContext!
    var databaseInteractor: CoreDataInteractor!
    
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
        databaseInteractor = CoreDataInteractor(context: inMemoryObjectContext)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddUniqueCurrencyPair () {
        
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
        
        let expectation = XCTestExpectation(description: "Save currency pair")
        
        databaseInteractor.saveCurrencyPair(baseCurrency: currency1, destinationCurrency: currency2) { (success, error) in
            
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddDuplicateCurrencyPairThrowsError () {
        let currency1 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency1.name = "testCurrencyA"
        currency1.code = "testCodeA"
        currency1.imageName = "testPathA"
        
        let currency2 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency2.name = "testCurrencyB"
        currency2.code = "testCodeB"
        currency2.imageName = "testPathB"
        
        let currency3 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency3.name = "testCurrencyA"
        currency3.code = "testCodeA"
        currency3.imageName = "testPathA"
        
        let currency4 = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: inMemoryObjectContext) as! Currency
        currency4.name = "testCurrencyB"
        currency4.code = "testCodeB"
        currency4.imageName = "testPathB"
        
        do {
            try inMemoryObjectContext.save()
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
        
        let expectation = XCTestExpectation(description: "Save currency pair")
        
        databaseInteractor.saveCurrencyPair(baseCurrency: currency1, destinationCurrency: currency2) { (success, error) in
            
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
       let expectationFail = XCTestExpectation(description: "Save identical currency pair")
       
       databaseInteractor.saveCurrencyPair(baseCurrency: currency3, destinationCurrency: currency4) { (success, error) in
           
           XCTAssertFalse(success)
           expectationFail.fulfill()
       }
       wait(for: [expectationFail], timeout: 1.0)
        
    }
    
    func testFetchCurrencyPairs () {
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
        
       let expectation = XCTestExpectation(description: "Save currency pair")
        
        databaseInteractor.saveCurrencyPair(baseCurrency: currency1, destinationCurrency: currency2) { (success, error) in
            
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
        var currencyPairs: [CurrencyPair] = []
        do {
            currencyPairs = try databaseInteractor.fetchCurrencyPairs()
        } catch {
            print (error.localizedDescription)
            XCTFail()
        }
        XCTAssertEqual(currencyPairs.count, 1)
        XCTAssertNotNil(currencyPairs[0].baseCurrency)
        XCTAssertEqual(currencyPairs[0].baseCurrency?.code, "testCode1")
    }
    
    func testFetchCurrencies () {
        
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
        var currencyList: [Currency] = []
        // Create an expectation
        let expectation = self.expectation(description: "fetching")
        
        do {
            try self.databaseInteractor.fetchCurrencies { (currencies) in
                currencyList = currencies
                expectation.fulfill()
            }
        } catch let error{
            print (error.localizedDescription)
            XCTFail()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(currencyList.count, 2)
    }
    
}
