//
//  CurrencyPairListViewModel.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

protocol CurrencyPairListViewModel {
    typealias CurrenciesRatesUpdated = ()-> Void
    
    /**
     gets the currency pair view model at index.
     
     - Parameter index: index for specific currency
     
     */
    func getCurrencyPairForCellAtIndex(_ index: Int) -> CurrencyPairViewModel?
    
    /**
     Notifies model to start updating the rates for the pairs
     
     - Parameter completion: The completion block that will be executed on success.
     
     */
    func startCurrencyRateUpdates(completion:@escaping CurrenciesRatesUpdated) throws
    
    /**
     Notifies model to fetch currency pairs
     
     - Parameter completion: The completion block that will be executed on success.
     
     */
    func refreshDataSource(completion:@escaping CurrenciesRatesUpdated) throws
    
    /**
     Gets the number of currency pairs.
     
     - Parameter index: index for specific currency
     */
    func getNumberOfCurrencyPairs() -> Int
    
    /**
    Deletes the currency pair at index.
    
    - Parameter index: index for specific currency pair
    */
    func deleteCurrencyPairAtIndex(_ index: Int) throws
    
    
    /**
     Notifies model to fetch currencies from the db
     
     - Parameter dataContext: The NSManagedObjectContext that handles core data
     
     - Returns: an isntance of itself
     */
    static func getInstance(dataContext: NSManagedObjectContext, baseURL: String) -> CurrencyPairListViewModel
}
