//
//  ErrorHandler.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import UIKit

class ErrorHandler {
    
    enum MissingDataMessages: String {
        //should add an activity indicator here
        case missingInfoForLabel = "Retrieving..."
        case missingPairKey = "Unknown pair key"
    }
    
    public static func showSimpleErrorAlertOnController (_ parentController: UIViewController, error: Error) {
        
        var message = error.localizedDescription
        
        if let err = error as? CoreDataUtils.CoreDataErrors{
            message = CoreDataUtils.CoreDataErrors.getErrorMessage(error: err)
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))

        parentController.present(alertController, animated: true, completion: nil)
    }
    
    public static func showSimpleMessageAlertOnController (_ parentController: UIViewController, message: String) {
           
           let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))

           parentController.present(alertController, animated: true, completion: nil)
       }
}
