//
//  CoreDataInteractor.swift
//  TestRevolut
//
//  Created by Alex on 11/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

class CoreDataInteractor {
    
    //MARK: Static methods
    
    /**
     Insert a list of currencies to the database if there are none.
     
     - Parameter context: The targeted context.
     
     - Returns: true for success false for fail.
     */
    static func populateTestCurrenciesIfNeeded(context: NSManagedObjectContext, testCurrencies: [[String: Any]]) {
        
        let currenciesFetch = NSFetchRequest<Currency>(entityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue)
        
        do {
            let numberOfCurrencies = try context.count(for: currenciesFetch)
            if numberOfCurrencies == 0 {
                populateTestCurrencies(context: context, testCurrencies: CoreDataUtils.initialCurrencyListJSON)
            }
        } catch {
            print("Failed to fetch currencies with error: \(error.localizedDescription)")
        }
    }
    
    private static func populateTestCurrencies(context: NSManagedObjectContext, testCurrencies: [[String: Any]])  {
        
        var testCurrecyListJSON: [CurrencyJSONModel] = []
        
        //decode currencies from JSON
        do {
            let decoder = JSONDecoder()
            let jsonData = try JSONSerialization.data(withJSONObject: testCurrencies, options: .prettyPrinted)
            testCurrecyListJSON = try decoder.decode([CurrencyJSONModel].self, from: jsonData)
        } catch {
            print("Failed to deserialise json: \(error.localizedDescription)")
        }
        
        //insert currencies to DB
        
        let childManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childManagedObjectContext.parent = context
        childManagedObjectContext.perform {
            for currencyStruct in testCurrecyListJSON {
                let currency = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue, into: context) as! Currency
                currency.name = currencyStruct.name
                currency.code = currencyStruct.identifier
                currency.imageName = currencyStruct.imageName
            }
            
            //save context
            do {
                try childManagedObjectContext.save()
                context.performAndWait {
                    do {
                        // Saves the data from the child to the main context to be stored properly
                        try context.save()
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                print("Failed to save context error: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: type definitions
    typealias FetchCurrenciesRequestComplete = ([Currency]) -> Void
    
    //MARK: private variables
    private let context: NSManagedObjectContext
    
    
    //MARK: public methods
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    /**
     Fetches a list of currencies.
     
     - Parameter context: The targeted context for the operation.
     - Parameter completion: The completion block that will be executed on success.
     
     */
    func fetchCurrencies(excludedBasePair: Currency? = nil, completion: @escaping FetchCurrenciesRequestComplete) throws {
        
        let currenciesFetch = NSFetchRequest<Currency>(entityName: CoreDataUtils.ManagedObjectNames.Currency.rawValue)
        
        let sortDescriptor = NSSortDescriptor(key: "code", ascending: true)
        currenciesFetch.sortDescriptors = [sortDescriptor]
        
        if let excludedBasepairUnwrp = excludedBasePair, let excludedCurrencyCode = excludedBasepairUnwrp.code {
            let notSelfpredicate = NSPredicate(format: "code != %@", excludedCurrencyCode)
            currenciesFetch.predicate = notSelfpredicate
        }
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: currenciesFetch) { (asynchronousFetchResult) in
            
            // Retrieves an array of dogs from the fetch result `finalResult`
            guard let currencies = asynchronousFetchResult.finalResult else {
                return
            }
            
            completion(currencies)
        }
        
        do {
            try context.execute(asynchronousFetchRequest)
        } catch {
            throw CoreDataUtils.CoreDataErrors.fetchFail
        }
    }
    
    /**
     Saves 2 currencies as a pair.
     
     - Parameter baseCurrency: the source currency
     - Parameter destinationCurrency: the destination currency.
     - Parameter completion: callback when saving compeletes
     
     */
    func saveCurrencyPair(baseCurrency: Currency, destinationCurrency: Currency, completion: @escaping GeneralAsyncOperationCompletionFeedback) {
        do {
            let pairIsDuplicate = try currencyPairIsDuplicate(baseCurrency: baseCurrency, destinationCurrency: destinationCurrency)
            if pairIsDuplicate {
                completion(false, CoreDataUtils.CoreDataErrors.duplicateEntries)
                return
            }
        } catch let error {
            completion(false, error)
            return
        }
        
        let childManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childManagedObjectContext.parent = context
        childManagedObjectContext.perform {[weak self] in
            
            guard let selfUnwrp = self else {
                return
            }
            
            let currencyPair = NSEntityDescription.insertNewObject(forEntityName: CoreDataUtils.ManagedObjectNames.CurrencyPair.rawValue, into: selfUnwrp.context) as! CurrencyPair
            currencyPair.baseCurrency = baseCurrency
            currencyPair.destinationCurrency = destinationCurrency
            
            //save context
            do {
                try childManagedObjectContext.save()
                selfUnwrp.context.performAndWait {
                    
                    do {
                        try selfUnwrp.context.save()
                        DispatchQueue.main.async {
                            completion(true, nil)
                        }
                        
                    } catch {
                        print("Failure to save context: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            completion(false, error)
                            return
                        }
                    }
                }
            } catch {
                print("Failed to save context error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, error)
                    return
                }
            }
        }
    }
    
    private func currencyPairIsDuplicate(baseCurrency: Currency, destinationCurrency: Currency) throws -> Bool {
        
        guard let baseCurrencyCode = baseCurrency.code, let destinationCurrencyCode = destinationCurrency.code else {
            return false
        }
        
        let currenciesFetch = NSFetchRequest<CurrencyPair>(entityName: CoreDataUtils.ManagedObjectNames.CurrencyPair.rawValue)
        let fetchPredicate = NSPredicate(format: "baseCurrency.code == %@ AND destinationCurrency.code == %@", argumentArray: [baseCurrencyCode, destinationCurrencyCode])
        currenciesFetch.predicate = fetchPredicate
        
        do {
            let numberOfCurrencies = try context.count(for: currenciesFetch)
            if numberOfCurrencies == 0 {
                return false
            }
        } catch {
            throw CoreDataUtils.CoreDataErrors.fetchFail
        }
        
        return true
    }
    
    /**
     Fetches currency pairs
     
     - Parameter context: The targeted context.
     
     - Returns: true for success false for fail.
     */
    func fetchCurrencyPairs() throws -> [CurrencyPair] {
        
        let currencyPairsFetch = NSFetchRequest<CurrencyPair>(entityName: CoreDataUtils.ManagedObjectNames.CurrencyPair.rawValue)
        let sortDescriptor = NSSortDescriptor(key: "baseCurrency.code", ascending: true)
        currencyPairsFetch.sortDescriptors = [sortDescriptor]
        
        do {
            let currencies = try context.fetch(currencyPairsFetch)
            return currencies
        } catch {
            throw CoreDataUtils.CoreDataErrors.fetchFail
        }
    }
    
    func deleteCurrencyPair(_ currencyPair: CurrencyPair) throws {
        self.context.delete(currencyPair)
        try self.context.save()
    }
    
}
