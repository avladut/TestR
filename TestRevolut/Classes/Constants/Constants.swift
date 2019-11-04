//
//  Constants.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataUtils {
    enum ManagedObjectNames: String {
        case Currency = "Currency"
        case CurrencyPair = "CurrencyPair"
    }
    
    enum CoreDataErrors: Error {
        case saveContextFail
        case fetchFail
        case duplicateEntries
        
        static func getErrorMessage (error: CoreDataErrors) -> String {
            switch error {
            case .saveContextFail:
                return "Could not save data"
            case .fetchFail:
                return "Could not fetch data"
            case .duplicateEntries:
                return "Cannot inset duplicate entries"
            }
        }
    }
    
    enum CurrencyMemberNames: String {
        case currencyCode = "code"
        case currencyName = "name"
    }
    
    static let mainContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let initialCurrencyListJSON: [[String: Any]] = [
        [CurrencyJSONModel.CodingKeys.name.rawValue: "British pound",
         CurrencyJSONModel.CodingKeys.identifier.rawValue: "GBP",
         CurrencyJSONModel.CodingKeys.imageName.rawValue: ImageNames.FlagNames.FlagUK.rawValue],
        
        [CurrencyJSONModel.CodingKeys.name.rawValue: "US Dollar",
         CurrencyJSONModel.CodingKeys.identifier.rawValue: "USD",
         CurrencyJSONModel.CodingKeys.imageName.rawValue: ImageNames.FlagNames.FlagUS.rawValue],
        
        [CurrencyJSONModel.CodingKeys.name.rawValue: "Euro",
         CurrencyJSONModel.CodingKeys.identifier.rawValue: "EUR",
         CurrencyJSONModel.CodingKeys.imageName.rawValue: ImageNames.FlagNames.FlagEU.rawValue],
        ]
}

struct HTTPRequestUtils {
    static let baseURL = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios"
    static let separator = "&"
    
    enum HTTPRequestErrors: Error {
        case requestFailed
        
        var localizedDescription: String {
            switch self {
            case .requestFailed:
                return "Could not save data"
            }
        }
    }
    
    enum ParameterNames: String {
        case pairParam = "pairs"
    }
}

struct ImageNames {
    enum FlagNames: String {
        case FlagUK = "uk_flag"
        case FlagUS = "us_flag"
        case FlagEU = "eu_flag"
    }
}

struct StoryboardUtils {
    static let mainStoryboardName = "Main"
}

typealias GeneralAsyncOperationCompletionFeedback = (_ success: Bool, _ error: Error?) -> Void







