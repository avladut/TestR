//
//  CurrencyViewModel.swift
//  TestRevolut
//
//  Created by Alex on 13/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
protocol CurrencyViewModel {
    var imageName: String? { get }
    var currencyCode: String { get }
    var currencyName: String { get }
}
