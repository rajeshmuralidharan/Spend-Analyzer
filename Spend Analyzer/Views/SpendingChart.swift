//
//  SpendingChart.swift
//  Spend Analyzer
//
//  Created by RAJESH MURALIDHARAN on 8/19/25.
//

import Charts
import SwiftUI


struct SpendingChart: View {
    var categorizedSpending : [CategorizedSpend.PartiallyGenerated]?
    
    var body: some View {
        Chart (categorizedSpending ?? [], id: \.category) { spendCategory in
            
            SectorMark(angle: .value("Spend", Double(spendCategory.total ?? "0.0") ?? 0.0),
               innerRadius: .ratio(0.618),
               angularInset: 5)
            .foregroundStyle(by: .value("Category", spendCategory.category ?? ""))
            
        }
        .padding()
    }
}

#Preview {
    SpendingChart()
}
