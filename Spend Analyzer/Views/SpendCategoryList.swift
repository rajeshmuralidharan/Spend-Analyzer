//
//  SpendCategoryList.swift
//  Spend Analyzer
//
//  Created by RAJESH MURALIDHARAN on 8/19/25.
//

import SwiftUI

struct SpendCategoryList: View {
    
    var categorizedSpend: [CategorizedSpend.PartiallyGenerated]?
    @Binding var selectedCategoryIndex: Int
    
    
    var body: some View {
        
        let sortedCategorizedSpend = categorizedSpend?.sorted(by: { $0.category ?? "" < $1.category ?? "" })
        
        List(sortedCategorizedSpend ?? []) { spend in
            HStack {
                Text(spend.category ?? "")
                Spacer()
                Text("$\(spend.total ?? "0.00")")
            }
            .onTapGesture {
                self.selectedCategoryIndex = categorizedSpend!.firstIndex(of: spend) ?? 0
                NSLog("selected index \(self.selectedCategoryIndex)")
            }
        }
    }
}

