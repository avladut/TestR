//
//  CurrencyCell.swift
//  TestRevolut
//
//  Created by Alex on 11/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    public static let reuseIdentifier = "CurrencyCellReuseId"
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    public func config(currency: CurrencyViewModel) {
        
        self.lblCode.attributedText = FontsTextHadler.getAttributedTextFromString(currency.currencyCode, textType: .currencyLight)
        
        self.lblName.attributedText = FontsTextHadler.getAttributedTextFromString(currency.currencyName, textType: .currencyMain)
        
        if let imgName = currency.imageName {
            self.imgFlag.image = UIImage(named: imgName)
        }
    }
    
    public func clear() {
        self.lblCode.attributedText = nil
        self.lblName.attributedText = nil
        self.imgFlag.image = nil
    }
}
