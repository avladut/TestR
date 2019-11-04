//
//  CurrencyPairViewModelImpl.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
class CurrencyPairViewModelImpl {
    
    private var currencyPair: CurrencyPair!
    private var exchangeRate: String?
    private var pairKey: String?
    
    init (currencyPair: CurrencyPair) {
        self.currencyPair = currencyPair
    }
    
    public func getPairKey() -> String {
        
        if let pairKeyText = self.pairKey {
            return pairKeyText
        }
        
        guard let baseCurrencyCode = currencyPair.baseCurrency?.code,
            let destinationCurrencyCode = currencyPair.destinationCurrency?.code else {
                return ErrorHandler.MissingDataMessages.missingPairKey.rawValue
        }
        return "\(baseCurrencyCode)\(destinationCurrencyCode)"
    }
}

extension CurrencyPairViewModelImpl: CurrencyPairViewModel {
    var currencyExchangeRate: String? {
        get {
            return self.exchangeRate
        }
        set {
            self.exchangeRate = newValue
        }
    }
    
    var pairKeyIdentifier: String {
        return getPairKey()
    }
    
    var sourceCurrencyTitle: String {
        guard let srcCurrencyCode = self.currencyPair.baseCurrency?.code else {
            return ErrorHandler.MissingDataMessages.missingInfoForLabel.rawValue
        }
        
        return "1 \(srcCurrencyCode)"
    }
    
    var destinationCurrencyTitle: String {
        guard let exchangeRateString = self.currencyExchangeRate, let exchangeRateDouble = Double(exchangeRateString) else {
            return ErrorHandler.MissingDataMessages.missingInfoForLabel.rawValue
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.locale = Locale.current

        let rateString = currencyFormatter.string(from: NSNumber(value: exchangeRateDouble))
        
        return rateString ?? "Error..."
    }
    
    var sourceCurrencySubtitle: String {
        guard let srcCurrencyName = self.currencyPair.baseCurrency?.name else {
            return ErrorHandler.MissingDataMessages.missingInfoForLabel.rawValue
        }
        
        return srcCurrencyName
    }
    
    var destinationCurrencySubtitle: String {
        guard let destCurrencyName = self.currencyPair.destinationCurrency?.name else {
            return ErrorHandler.MissingDataMessages.missingInfoForLabel.rawValue
        }
        
        return destCurrencyName
    }
}
