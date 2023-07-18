//
//  SecondPageView.swift
//  CashApp
//
//  Created by Oliver Zheng on 7/14/23.
//

import SwiftUI

struct SecondPageView: View {
    
    var stocks: Stocks
    @State var total: Double = 0.0
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: StockServerMode
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("\(stocks.name)")
                    .font(.headline)
                Text("\(stocks.currency) \(String(format: "%.2f", (Double(Double(stocks.current_price_cents)/100))))")
                    .font(.subheadline)
                    .padding(.vertical)
                HStack{
                    VStack{
                        Text("Shared")
                        Text("\(stocks.quantity ?? 0)")
                    }
                    Spacer()
                    VStack{
                        Text("Market Value")
                        Text("\(String(format: "%.2f", Double(Double(total )/100)))")
                            .onAppear{ calTrade() }
                    }
                }
            }
            HStack{
                Spacer()
                Button(action: {} ){
                    Text("Trade")
                }
                .frame(width: 120, height: 35, alignment: .center)
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                Spacer()
            }
            Text("Other Stocks you may like")
                .padding(.vertical)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black)
        .foregroundColor(.white)
        
        
    }
    
    private var filteredData: [Stocks] {
        return viewModel.stocks.filter { $0.quantity == nil}
    }
    private func calTrade(){
        if stocks.quantity != nil{
            let currentPrice = stocks.current_price_cents
            let quantity = stocks.quantity
            self.total = Double(currentPrice * quantity!)
        }else{
            self.total = 0
        }
          
       }
    
    
}

//struct SecondPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SecondPageView(stocks: <#Stocks#>, path: NavigationPath())
//    }
//}
