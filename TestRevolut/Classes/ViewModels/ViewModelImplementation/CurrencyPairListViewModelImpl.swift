//
//  CurrencyPairListViewModelImpl.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

class CurrencyPairListViewModelImpl {
    
    private var currencyPairs: [CurrencyPairViewModel] = []
    private var currencyPairsManagedObjects: [CurrencyPair] = []
    
    private let databaseInteractor: CoreDataInteractor!
    private let webInteractor: WebAPIInteractor!
    
    init (dataContext: NSManagedObjectContext, baseURL: String) {
        self.databaseInteractor = CoreDataInteractor(context: dataContext)
        self.webInteractor = WebAPIInteractor(baseUrlString: baseURL)
    }
    
    private func updateCurrencyPairsExchangeRates (ratesDictionary: [String: Any]) {
        for (key, value) in ratesDictionary {
            guard let valueString = value as? Double else {
                return
            }

            var currencyPair = self.currencyPairs.first( where: { $0.pairKeyIdentifier == key })
            currencyPair?.currencyExchangeRate = "\(valueString)"
        }
    }
}

extension CurrencyPairListViewModelImpl: CurrencyPairListViewModel {
    
    func deleteCurrencyPairAtIndex(_ index: Int) throws {
        guard currencyPairsManagedObjects.count > index else {
            //throw someting
            return
        }
        try databaseInteractor.deleteCurrencyPair(currencyPairsManagedObjects[index])
        self.currencyPairs.remove(at: index)
        self.currencyPairsManagedObjects.remove(at: index)
    }
    
    
    func refreshDataSource(completion: @escaping CurrenciesRatesUpdated) throws {
        do {
            self.currencyPairsManagedObjects = try databaseInteractor.fetchCurrencyPairs()
            currencyPairs = currencyPairsManagedObjects.map({ (currencyPairMangedObject) -> CurrencyPairViewModel in
                return CurrencyPairViewModelImpl(currencyPair: currencyPairMangedObject)
            })
            
            completion ()
            
        } catch let error{
            throw error
        }
    }
    
    func startCurrencyRateUpdates(completion: @escaping CurrenciesRatesUpdated) throws {
        
        let currencyPairString = self.currencyPairs.map { (currencyPair) -> String in
            return currencyPair.pairKeyIdentifier
        }
        webInteractor.requestRatesForCurrencyPairs(currencyPairString, success: { [weak self] (response) in
            self?.updateCurrencyPairsExchangeRates(ratesDictionary: response)
            completion()
            
            }, fail: { (errorMessage) in
            print(errorMessage)
        })

    }
    
    func getCurrencyPairForCellAtIndex(_ index: Int) -> CurrencyPairViewModel? {
        return currencyPairs.count > index ? currencyPairs[index] : nil
    }
    
    func getNumberOfCurrencyPairs() -> Int {
        return self.currencyPairs.count
    }
    
    static func getInstance(dataContext: NSManagedObjectContext, baseURL: String) -> CurrencyPairListViewModel {
        return CurrencyPairListViewModelImpl(dataContext: dataContext, baseURL: baseURL)
    }
}
