//
//  FontsTextHandler.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

class FontsTextHadler {
    
    
    enum TextTypes {
        case screenTitle
        case exchangeTitle
        case exchangeSubtitle
        case currencyMain
        case currencyLight
    }
    
    enum FontNames: String {
        case regularFont = "Roboto-Regular"
        case mediumFont = "Roboto-Medium"
    }
    
    private struct TextProperties {
        var textColor: UIColor
        var lineSpacing: CGFloat
        var font: UIFont
    }
    
    private struct AppFonts {
        static let exchangeTitleFont = UIFont(name: FontNames.regularFont.rawValue, size: 20)!
        static let exchangeSubtitleFont = UIFont(name: FontNames.mediumFont.rawValue, size: 14)!
        static let currencyFont = UIFont(name: FontNames.regularFont.rawValue, size: 16)!
    }
    
    //All the data regarding fonts
    private static let textPropertyList: [TextTypes: TextProperties] = [
        //Text props for exchange main
        .exchangeTitle: TextProperties(textColor: UIColor(red: 0.1, green: 0.11, blue: 0.12, alpha: 1),
                                       lineSpacing: 5,
                                       font: AppFonts.exchangeTitleFont),
        
        //Text props for exchange subtitle
        .exchangeSubtitle: TextProperties(textColor:  UIColor(red: 0.55, green: 0.58, blue: 0.62, alpha: 1),
                                          lineSpacing: 4,
                                          font: AppFonts.exchangeSubtitleFont),
        
        //Text props for currency name
        .currencyMain: TextProperties(textColor:  UIColor(red: 0.1, green: 0.11, blue: 0.12, alpha: 1),
                                      lineSpacing: 5,
                                      font: AppFonts.currencyFont),
        
        //Text props for currency code
        .currencyLight: TextProperties(textColor: UIColor(red: 0.55, green: 0.58, blue: 0.62, alpha: 1),
                                       lineSpacing: 5,
                                       font: AppFonts.currencyFont),
        
        //Text props for app title
        .screenTitle: TextProperties(textColor:  UIColor(red: 0.1, green: 0.11, blue: 0.12, alpha: 1),
                                     lineSpacing: 5,
                                     font: AppFonts.currencyFont)
        
    ]
    
    
    /**
     Insert a list of currencies to the database if there are none.
     
     - Parameter textString: The text to be formatted
     - Parameter the text type: The type of format to be applied
     
     - Returns: formatted text.
     */
    public static func getAttributedTextFromString(_ textString: String, textType: TextTypes) -> NSAttributedString {
        
        guard let textProperties = textPropertyList[textType] else {
            return NSAttributedString(string: textString)
        }
        return getAttributedTextWithProperties(textString, textProperties: textProperties)
    }
    
    private static func getAttributedTextWithProperties (_ textString: String, textProperties: TextProperties) -> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textProperties.lineSpacing
        let attributedText = NSMutableAttributedString(string: textString, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: textProperties.font, NSAttributedString.Key.foregroundColor: textProperties.textColor])
        return attributedText
    }
}

