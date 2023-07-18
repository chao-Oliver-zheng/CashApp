//
//  StockServer.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/12/23.
//

import Foundation

protocol StockServerProtocol {
    func fetchData() async throws -> [Stocks]
}

class StockServer: StockServerProtocol {
    
    
    func fetchData() async throws -> [Stocks] {
        let fetchurl = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio.json"
        //let fetchurl = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_empty.json"
        //let fetchurl = "https://storage.googleapis.com/cash-homework/cash-stocks-api/portfolio_malformed.json"
        guard let url = URL(string: fetchurl) else { throw APIError.invalidUrl}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else{
            throw APIError.invalidResponse
        }
        let StocksResponse = try JSONDecoder().decode(StocksResponse.self, from: data)
        return StocksResponse.stocks
    }
    
}
