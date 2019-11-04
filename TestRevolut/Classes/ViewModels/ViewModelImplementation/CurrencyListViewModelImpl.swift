//
//  CurrencyListViewModelImpl.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

class CurrencyListViewModelImpl {
    
    private var currencies: [Currency]
    private let dbInteractor: CoreDataInteractor
    
    private var savedCurrencyPair: [SavedCurrencyPairKey: Currency] = [:]
    
    init(dataContext: NSManagedObjectContext) {
        self.currencies = []
        self.dbInteractor = CoreDataInteractor(context: dataContext)
    }
    
    private func shouldAttemptToSaveCurrencyPair() -> Bool {
        
        
        return true
    }
}

extension CurrencyListViewModelImpl: CurrencyListViewModel {
    
    func saveCurrencyWithPositionForPair(index: Int, key: SavedCurrencyPairKey, callback: @escaping GeneralAsyncOperationCompletionFeedback) {
        if currencies.count > index {
            savedCurrencyPair[key] = currencies[index]
        }
        guard let baseCurrency = savedCurrencyPair[.baseCurrency],
            let destinationCurrency = savedCurrencyPair[.destinationCurrency] else {
                //only one of the currencies from pair was stored in memory
                callback(true, nil)
                return
        }
        dbInteractor.saveCurrencyPair(baseCurrency: baseCurrency, destinationCurrency: destinationCurrency, completion: callback)
    }
    
    
    func getCurrencies(shouldExcludeExistingPairs: Bool, completion: @escaping () -> Void) throws {
        
        let excludedCurrency = shouldExcludeExistingPairs ? savedCurrencyPair[SavedCurrencyPairKey.baseCurrency] : nil
        do {
            try dbInteractor.fetchCurrencies(excludedBasePair: excludedCurrency, completion: {[weak self] (currenciesManagedObjects) in
                self?.currencies = currenciesManagedObjects
                completion()
            })
        } catch {
            throw error
        }
    }
    
    func getCurrencyForCellAtIndex(_ index: Int) -> CurrencyViewModel? {
        return currencies.count > index ? CurrencyViewModelImpl(currency: currencies[index]) : nil
    }
    
    func getNumberOfCurrencies() -> Int {
        return currencies.count
    }
    
    static func getInstance(dataContext: NSManagedObjectContext) -> CurrencyListViewModel {
        return CurrencyListViewModelImpl(dataContext: dataContext)
    }
}
