//
//  CurrencyListViewModel.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import CoreData

enum SavedCurrencyPairKey: String {
    case baseCurrency = "baseCurrency"
    case destinationCurrency = "destinationCurrency"
}

protocol CurrencyListViewModel {
    
    typealias CurrenciesUpdated = ()-> Void
    
    
    /**
     gets the currency view model at index.
     
     - Parameter index: index for specific currency
     
     */
    func getCurrencyForCellAtIndex(_ index: Int) -> CurrencyViewModel?
    
    /**
     Notifies model to fetch currencies from the db
    
     - Parameter completion: The completion block that will be executed on success.
     - Parameter shouldExcludeExistingpairs: if true will exclude the selected currency
     
     */
    func getCurrencies(shouldExcludeExistingPairs: Bool, completion:@escaping CurrenciesUpdated) throws
    
    /**
     Gets the number of currencies.
     
     - Parameter index: index for specific currency
     */
    func getNumberOfCurrencies() -> Int
    
    /**
     Notifies model to save currency pairs
     
     - Parameter index: index of the pair
     
     - Parameter key: type of currency, base or destination
     
     */
    func saveCurrencyWithPositionForPair(index: Int, key: SavedCurrencyPairKey, callback: @escaping GeneralAsyncOperationCompletionFeedback)
    
    /**
     Notifies model to fetch currencies from the db
     
     - Parameter dataContext: The NSManagedObjectContext that handles core data
     
     - Returns: an isntance of itself
     */

    static func getInstance(dataContext: NSManagedObjectContext) -> CurrencyListViewModel
}
