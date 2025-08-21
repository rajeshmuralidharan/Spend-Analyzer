//
//  TransactionsForCategoryView.swift
//  Spend Analyzer
//
//  Created by RAJESH MURALIDHARAN on 8/19/25.
//

import SwiftUI

struct TransactionsForCategoryView: View {
    var transactions: [TransactionData.PartiallyGenerated]?
    var body: some View {
        
        let sortedTransactions = transactions?.sorted(by: { $0.postedDate ?? "" > $1.postedDate ?? "" })
        
        List(sortedTransactions ?? []) { transaction in
            HStack {
                Text(transaction.postedDate ?? "")
                Spacer()
                Text(transaction.description ?? "")
                Spacer()
                Text(transaction.amount ?? "")
                
            }
            
        }
    }
}

