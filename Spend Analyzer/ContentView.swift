//
//  ContentView.swift
//  Spend Analyzer
//
//  Created by RAJESH MURALIDHARAN on 8/19/25.
//

import Charts
import SwiftUI


struct ContentView: View {
    
    @StateObject var vm = TransactionDataViewModel()
    @State var selectedCategoryIndex = 0
    @State var days : String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Number of days")
                
                TextField("10", text: $days)
                Spacer()
                
                Button("Analyze") {
                    selectedCategoryIndex = 0
                    vm.analyzeSpendAsync(forDays: days)
                }
            }
            .padding()
            
            VStack {
                HStack {
                    
                    SpendingChart(categorizedSpending: vm.categorizedSpend)
                     
                    
                    Spacer()
                    
                    SpendCategoryList(categorizedSpend: vm.categorizedSpend, selectedCategoryIndex: $selectedCategoryIndex)
                     
                    Spacer()
                }
                
                
                if (vm.categorizedSpend != nil
                    && vm.categorizedSpend?.count ?? 0 > 0) {
                    
                    TransactionsForCategoryView(transactions: vm.categorizedSpend?[selectedCategoryIndex].transactions)
                    
                }
                 
            }
            
           
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
