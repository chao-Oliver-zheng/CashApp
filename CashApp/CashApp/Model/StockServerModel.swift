//
//  StockServerModel.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/12/23.
//

import Foundation
import Combine

class StockServerMode: ObservableObject {
    
    @Published var stocks: [Stocks] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    //@publish var state: APIState = .init
    let service: StockServerProtocol
    
   // private let service = StockServer()
    init(service: StockServerProtocol = StockServer()) {
        self.service = service
        Task {
            await getData()
        }
    }
    
    @MainActor func getData() {
        isLoading = true
        Task {
            do{
                let stocks: [Stocks] = try await service.fetchData()
                self.stocks = stocks
                isLoading = false
            } catch {
                if  let error = error as? APIError  {
                    print(error.description)
                    errorMessage = error.description
                } else {
                    print(error)
                    errorMessage = error.localizedDescription
                }
            }
            
        }
    }
    
}
