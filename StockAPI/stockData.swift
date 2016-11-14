//
//  stockData.swift
//  StockAPI
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import Foundation
import UIKit

class stockData {
    var ticker: String
    var percent: Double

    
    init(ticker: String, percent: Double) {
        self.ticker = ticker
        self.percent = percent
            }
}
