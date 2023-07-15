//
//  SecondPageView.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/14/23.
//

import SwiftUI

struct SecondPageView: View {
    
    @StateObject var viewModel = StockServerMode()
    var stocks: Stocks
    @State var total: Double = 0.0
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            Button(action: { path = NavigationPath() }) {
                
                Text("home")
            }
            Spacer()
            if let _ = stocks.quantity {
                Text("\(stocks.name) total is \(stocks.currency)\(String(format: "%.2f", total))")
                    .onAppear{ calTrade() }
            } else {
                Text("Buy something")
            }
            
            List {
                ForEach(filteredData , id:\.self){ stock in
                    
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
                                }
                                Spacer()
                            }
                        }
                        .navigationDestination(for: Stocks.self){ item in
                            SecondPageView(stocks: item, path: $path)
                            
                        }
                    }
                }
                .listStyle(.plain)
                .edgesIgnoringSafeArea(.all)
            }
            
            
            
        }
    }
        
    private var filteredData: [Stocks] {
        viewModel.stocks.filter { stock in
            
            !stocks.name.contains(stock.name)
        }
    }
    
    private func calTrade(){
        
        let currentPrice = stocks.current_price_cents
        let quantity = stocks.quantity
        self.total = Double(currentPrice * quantity!)
       
    }
    
}
//
//struct SecondPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondPageView()
//    }
//}
