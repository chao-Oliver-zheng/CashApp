//
//  Stock.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/12/23.
//

import Foundation

struct StocksResponse: Codable, Hashable {
    let stocks: [Stocks]
}

struct Stocks: Codable, Hashable {
    let ticker: String
    let name: String
    let currency: String
    let current_price_cents: Int
    let quantity: Int?
    let current_price_timestamp: Int
}
