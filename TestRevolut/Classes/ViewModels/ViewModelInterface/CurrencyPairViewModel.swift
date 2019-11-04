//
//  CurrencyPairViewModel.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
protocol CurrencyPairViewModel {
    
    var sourceCurrencyTitle: String { get }
    var destinationCurrencyTitle: String { get }
    var sourceCurrencySubtitle: String { get }
    var destinationCurrencySubtitle: String { get }
    
    var pairKeyIdentifier: String { get }
    var currencyExchangeRate: String? { get set }
}
