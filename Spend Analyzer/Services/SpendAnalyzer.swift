//
//  NeighborhoodDataFetcher.swift
//  Sim Data
//
//  Created by RAJESH MURALIDHARAN on 7/28/25.
//

import Swift
import Foundation
import FoundationModels
internal import Combine


class SpendAnalyzer : ObservableObject{
    
    static let shared = SpendAnalyzer( )
    
    private var model = SystemLanguageModel.default
    private var schemaSent = false
    private var session : LanguageModelSession?
 
    var isResponding = false
    @Published var llmResponse = ""
   
    
    init( ) {
        let instructions = loadInstructions()
        initiateSessionWith(instructions: instructions)
    }
    
    func loadInstructions() -> String {

        do {
            let data = try FileLoader.loadBundleFile(named: "instruction", withExtension: "txt")
            return String(data: data, encoding: .utf8) ?? "No instruction"
        } catch {
            fatalError("Failed to read Instructions.txt: \(error)")
        }
    }
    
    func initiateSessionWith(instructions: String) -> Void {
        session = LanguageModelSession(tools: [TransactionsTool()], instructions: instructions)
        session?.prewarm()
    }
    
    func fetch(prompt: String) async -> AsyncStream<[CategorizedSpend.PartiallyGenerated]?> {
        
        return AsyncStream <[CategorizedSpend.PartiallyGenerated]?>{ continuation in
           Task {
               let stream  = session?.streamResponse(to: prompt, generating: AllSpendCategorized.self, options: GenerationOptions(temperature: 0.1))
               guard let stream else {
                   return
               }
               do {
                   for try await partialResponse in stream {
                       continuation.yield(partialResponse.content.categorizedSpends)
                   }
                   
               } catch LanguageModelSession.GenerationError.guardrailViolation {
                   logGuardilineViolation(entry: session?.transcript.last)
               }
           }
       }
        
    }
            
         
    
    
    func fetchSync(prompt: String) async -> AllSpendCategorized? {
        do {
            let value = try await session?.respond(to: prompt,  generating: AllSpendCategorized.self, options: GenerationOptions(temperature: 0.1))
            schemaSent = true
            return value?.content as AllSpendCategorized?
        } catch {
            return nil
        }
    }
    
    func logGuardilineViolation(entry: Transcript.Entry?) -> Void {
        /*
        let feedback = LanguageModelFeedbackAttachment(
            input: Array((session?.transcript.prefix(while: { $0 != entry }))!),
            output: [entry!], sentiment: .negative
            )


        // Convert the feedback to JSON.
        let json = try! JSONEncoder().encode(feedback)
        
        saveToFile(text: String(data: json, encoding: .utf8)!)
*/
    }
    
    func saveToFile(text: String) -> Void {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectoryUrl = urls[0]
        let fileUrl = documentDirectoryUrl.appendingPathComponent("simdata.json")
        do {
            try text.write(to: fileUrl, atomically: true, encoding: .utf8)
        } catch {
            
        }
    }
       
    
   
}
