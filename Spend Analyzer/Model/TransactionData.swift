//
//  TransactionData.swift
//  Tools PoC
//
//  Created by RAJESH MURALIDHARAN on 8/6/25.
//

import Foundation
import FoundationModels

@Generable
struct TransactionData: Codable, Equatable, CaseIterable, Identifiable  {
    static var allCases = [] as [TransactionData]
    
    var id: String {
        String("\(postedDate) \(description) \(amount)".hashValue)
    }
    
    var postedDate: String
    var description: String
    var category: String
    var amount: String
}

@Generable
struct CategorizedSpend : Codable, Equatable, Identifiable  {
    var id: String {
        String("\(category) \(total)".hashValue)
    }
    
    var category: String
    var total: String
    var transactions: [TransactionData]?
    
}

@Generable
struct AllSpendCategorized: Codable, Equatable, Identifiable  {
    var id: String {
        UUID().uuidString
    }
    
    var categorizedSpends: [CategorizedSpend]?
}
