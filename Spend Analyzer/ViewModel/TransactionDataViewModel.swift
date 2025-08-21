//
//  TransactionDataViewModel.swift
//  Tools PoC
//
//  Created by RAJESH MURALIDHARAN on 8/6/25.
//

import Swift
import SwiftUI
internal import Combine


class TransactionDataViewModel : ObservableObject {

    @Published var spend: AllSpendCategorized?
    @Published var categorizedSpend : [CategorizedSpend.PartiallyGenerated]?
    @Published var analyzedSpend: String = ""
    @Published var transactionsForSelectedCategory: [TransactionData]? = []
    
    
    func analyzeSpend(forDays : String)  -> Void {
        let analyzer = SpendAnalyzer()
        
        Task {
            let result = await analyzer.fetchSync(prompt: "Categorize my spending for that last \(forDays) days. Group spend category and associated transactions.")
            
            if let result = result {
                await MainActor.run {
                    spend = result
                }
                
            }
        }
       
    }
    
    func analyzeSpendAsync(forDays : String) -> Void {
        let analyzer = SpendAnalyzer()
        
        Task {
            for try await spendResponse in await analyzer.fetch(prompt: "Categorize my spending for that last \(forDays) days. Group spend category and associated transactions.") {
                await MainActor.run {
                    categorizedSpend = spendResponse
                }
            }
        }
    }
    
    func handleCategorySelection(category: String) -> Void {
        
    }
    
    
    
    
}
