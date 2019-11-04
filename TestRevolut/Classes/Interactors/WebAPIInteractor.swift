//
//  WebAPIInteractor.swift
//  TestRevolut
//
//  Created by Alex on 11/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
class WebAPIInteractor {
    
    typealias RequestCompleteSuccess = ([String: Any]) -> Void
    typealias RequestFailed = (String) -> Void
    
    private let baseUrlString: String!
    
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }
    
    public func requestRatesForCurrencyPairs(_ currencyPairs: [String],
                                             success: @escaping RequestCompleteSuccess,
                                             fail: @escaping RequestFailed) {
        
        var urlComponents = URLComponents(string: baseUrlString)!
        urlComponents.queryItems = currencyPairs.map { (value) in
            URLQueryItem(name: "pairs", value: value)
        }
        
        let request = URLRequest(url: urlComponents.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    fail("error")
                    return
            }
            
            DispatchQueue.global(qos: .background).async {
                if let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] {
                    DispatchQueue.main.async {
                        success(responseObject)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    
}
