//
//  ContentView.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = StockServerMode()
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                if viewModel.isLoading {
                    Text("Loading")
                } else if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                } else if viewModel.stocks.count == 0 {
                    Text("Something is wrong with server, \n Please try again later")
                        .foregroundColor(.red)
                }else {
                    VStack{
                        List {
                            Section("Stock you have"){
                                
                                ForEach(viewModel.stocks, id:\.self){ stock in
                                   
                                        if let hold = stock.quantity {
                                            NavigationLink(value: stock){
                                                HStack{
                                                    VStack(alignment: .leading) {
                                                        Text(stock.ticker)
                                                            .font(.headline)
                                                        Text(stock.name)
                                                            .font(.subheadline)
                                                        HStack{
                                                            Text(stock.currency)
                                                            Text("\(stock.current_price_cents)")
                                                                .font(.subheadline)
                                                        }
                                                        Text(getTime(stock:stock))
                                                        
                                                    }
                                                    Spacer()
                                                    Text("\(hold)")
                                                }
                                            }
                                            .navigationDestination(for: Stocks.self){ item in
                                                SecondPageView(stocks: item, path: $path)
                                            
                                        }
  
                                    }
                                }
                            }
                            
                            Section("Other Stocks"){
                                ForEach(viewModel.stocks, id:\.self){ stock in
                                    if let _ = stock.quantity {}
                                    else{
                                        NavigationLink(value: stock){
                                            HStack{
                                                VStack(alignment: .leading) {
                                                    Text(stock.ticker)
                                                        .font(.headline)
                                                    Text(stock.name)
                                                        .font(.subheadline)
                                                    HStack{
                                                        Text(stock.currency)
                                                        Text("\(stock.current_price_cents)")
                                                            .font(.subheadline)
                                                    }
                                                    Text(getTime(stock:stock))
                                                    
                                                }
                                                Spacer()
                                            }
                                        }
                                        .navigationDestination(for: Stocks.self){ item in
                                            SecondPageView(stocks: item, path: $path)
                                        }
                                        
                                    }
                                }
                            }
                           
                            
                            
                            
                            
                        }
                       
                        
                    }
                }
            }
            .onAppear{
                Task.detached {
                    await viewModel.getData()
                }
                
            }
        }
    }
    private func getTime(stock: Stocks) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: stock.current_price_timestamp)
        let curDate = Date()
        return dateFormatter.string(from: curDate)
        
    }
        
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
