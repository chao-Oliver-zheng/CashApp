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
            ScrollView(showsIndicators: false){
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
                        VStack(alignment: .leading){
                            Text("Investing")
                                .font(.system(size: 30).bold())
                            Text("$ \(total)")
                                .font(.system(size: 30).bold())
                            
                                
                            Text("Stocks")
                                .font(.headline)
                            ForEach(filteredData, id:\.self) { stock in
                                NavigationLink(value: stock){
                                    if let hold = stock.quantity {
                                        HStack{
                                            VStack(alignment: .leading) {
                                                Text(stock.ticker)
                                                    .font(.headline)
                                                Text("\(hold) shares")
                                                    .font(.subheadline)
                                                    .opacity(0.9)
                                            }
                                            Spacer()
                                            HStack{
                                                Text(stock.currency)
                                                Text("\(String(format: "%.2f", (Double(Double(stock.current_price_cents)/100))))")
                                                    .font(.subheadline)
                                            }
                                            .frame(width: 120, height: 35, alignment: .center)
                                            .background(.green)
                                            .cornerRadius(10)
                                        }
                                        
                                    } else{
                                        HStack{
                                            VStack(alignment: .leading) {
                                                Text(stock.ticker)
                                                    .font(.headline)
                                                Text(stock.name)
                                                    .font(.subheadline)
                                                    .opacity(0.9)
                                            }
                                            Spacer()
                                            HStack{
                                                Text(stock.currency)
                                                Text("\(String(format: "%.2f", (Double(Double(stock.current_price_cents)/100))))")
                                                    .font(.subheadline)
                                            }
                                            .frame(width: 120, height: 35, alignment: .center)
                                            .background(.green)
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                            .navigationDestination(for: Stocks.self){ item in
                                SecondPageView(stocks: item, path: $path, viewModel: viewModel)
                            }
                            .listStyle(.grouped)
                        }
                    }
                }
               
                .onAppear{ viewModel.getData()}
               
                //.navigationBarTitleDisplayMode(.inline)
                
                
                
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
        }
        
        
    }
       
    private var filteredData: [Stocks] {
        let sortedData = viewModel.stocks.sorted{ stock1, stock2 in
            
            if let quant1 = stock1.quantity, let quant2 = stock2.quantity {
                return quant1 < quant2
            }
            return stock1.quantity != nil
        }
        return sortedData
    }
    private var total: String {
        var cur: Double = 0.0
        for obj in  viewModel.stocks{
            print(obj.current_price_cents)
            if let qua = obj.quantity {
                cur += (Double(obj.current_price_cents) * Double(qua))
            }else{ }
        }
        cur = Double(cur/100)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: cur))!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
