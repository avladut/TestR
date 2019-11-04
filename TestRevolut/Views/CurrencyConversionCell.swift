//
//  CurrencyConversionCell.swift
//  TestRevolut
//
//  Created by Alex on 11/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class CurrencyConversionCell: UITableViewCell {
    
    static let reuseIdentifier = "CurrencyConversionCellReuseId"
    
    @IBOutlet weak var lblSourceCurrencyTitle: UILabel!
    
    @IBOutlet weak var lblSourceCurrencySubtitle: UILabel!
    
    @IBOutlet weak var lblDestinationCurrencyTitle: UILabel!
    @IBOutlet weak var lblDestinationCurrencySubtitle: UILabel!
    
    
    public func config(_ currencyPairModel: CurrencyPairViewModel?) {
        
        guard let currencyPair = currencyPairModel else {
            return
        }
        
        
        self.lblSourceCurrencyTitle.attributedText = FontsTextHadler.getAttributedTextFromString(currencyPair.sourceCurrencyTitle, textType: .exchangeTitle)
        
        self.lblSourceCurrencySubtitle.attributedText = FontsTextHadler.getAttributedTextFromString(currencyPair.sourceCurrencySubtitle, textType: .exchangeSubtitle)
        
        self.lblDestinationCurrencyTitle.attributedText = FontsTextHadler.getAttributedTextFromString(currencyPair.destinationCurrencyTitle, textType: .exchangeTitle)
        
        self.lblDestinationCurrencySubtitle.attributedText = FontsTextHadler.getAttributedTextFromString(currencyPair.destinationCurrencySubtitle, textType: .exchangeSubtitle)
    }
    
    public func clear() {
        self.lblSourceCurrencyTitle.attributedText = nil
        self.lblSourceCurrencySubtitle.attributedText = nil
        self.lblDestinationCurrencyTitle.attributedText = nil
        self.lblDestinationCurrencySubtitle.attributedText = nil
    }
}
