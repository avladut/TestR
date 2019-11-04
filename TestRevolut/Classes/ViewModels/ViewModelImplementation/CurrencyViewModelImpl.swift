//
//  CurrencyViewModelImpl.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
class CurrencyViewModelImpl {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
}

extension CurrencyViewModelImpl: CurrencyViewModel {
    var imageName: String? {
        return currency.imageName
    }
    
    var currencyCode: String {
        return currency.code ?? "Unknown"
    }
    
    var currencyName: String {
        return currency.name ?? "Unknown"
    }
}
