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
    private let service = StockServer()
    
    private let updateInterval: TimeInterval = 5 // Update interval in seconds
    private var updateTimer: Timer?
    init() {
            startUpdating()
        }
    deinit {
            stopUpdating()
        }
    private func startUpdating() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.getData()
        }
        
        updateTimer?.fire()
    }
    private func stopUpdating() {
           updateTimer?.invalidate()
           updateTimer = nil
       }
    
    @MainActor func getData() {
        isLoading = true
        Task {
            do{
                let stocks: [Stocks] = try await service.fetchData()
                self.stocks = stocks
            } catch {
                if  let error = error as? APIError  {
                    print(error.description)
                    errorMessage = error.description
                } else {
                    print(error)
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
    
}
