//
//  CurrencyJSONModel.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation

struct CurrencyJSONModel: Codable {
    
    let name: String
    let identifier: String
    let imageName: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case identifier
        case imageName
    }
}
