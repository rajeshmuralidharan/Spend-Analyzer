//
//  CustomerTool.swift
//  Tools PoC
//
//  Created by RAJESH MURALIDHARAN on 8/7/25.
//

import Foundation
import FoundationModels

final class TransactionsTool : Tool {
    
    let name = "findTransactionTool"
    let description: String = "Finds the spend transactions for a given number of days"
    
    @Generable
    struct Arguments {
        @Guide(description: "This is the number of days for which spend transactions are being analyzed")
        var days: Int
    }
    
    @Generable
    struct Output {
        var transactions: [TransactionData]?
    }
    
    func call(arguments: Arguments) async throws -> Output {
        NSLog("Argument passed \(arguments.days)")
        return Output(transactions: getTransactions(lessThan: arguments.days))
    }
    
    private func getTransactions(lessThan days: Int = 30) -> [TransactionData]? {
        do {
            let data = try FileLoader.loadBundleFile(named: "testdata", withExtension: "json")
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let transactions = try decoder.decode([TransactionData].self, from: data)
            let filteredTransactions = transactions.filter{isDate($0.postedDate, thanDays: days) }
            return filteredTransactions
        } catch {
            return nil
        }
    
    }
    
    private func isDate(_ dateString: String, thanDays : Int) -> Bool {
        let today = Date()
        
        if let date = convertDate(dateString) {
            return Calendar.current.dateComponents([.day], from: date, to: today).day! <= thanDays
        }
        
        return false
    }
    
    private func convertDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: dateString)
    }
    
    
}
